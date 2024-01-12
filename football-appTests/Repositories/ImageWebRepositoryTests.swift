//
//  ImageWebRepositoryTests.swift
//  football-appTests
//
//  Created by James on 12/01/2024.
//

import XCTest
import Combine
import UIKit
@testable import football_app

final class ImageWebRepositoryTests: XCTestCase {
    private var sut: RealImageWebRepository!
    private var subscriptions = Set<AnyCancellable>()
    private lazy var testImage = UIColor.red.image(CGSize(width: 40, height: 40))
    
    typealias Mock = RequestMocking.MockedResponse

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = RealImageWebRepository(session: .mockedResponsesOnly,
                                     baseURL: "https://test.com")
    }

    override func tearDown() {
        RequestMocking.removeAllMocks()
    }

    func test_loadImage_success() throws {
        
        let imageURL = try XCTUnwrap(URL(string: "https://image.service.com/myimage.png"))
        let responseData = try XCTUnwrap(testImage.pngData())
        let mock = Mock(url: imageURL, result: .success(responseData))
        RequestMocking.add(mock: mock)
        
        let exp = XCTestExpectation(description: "Completion")
        sut.load(imageURL: imageURL).sinkToResult { result in
            switch result {
            case let .success(resultValue):
                XCTAssertEqual(resultValue.size, self.testImage.size)
            case let .failure(error):
                XCTFail("Unexpected error: \(error)")
            }
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_loadImage_failure() throws {
        let imageURL = try XCTUnwrap(URL(string: "https://image.service.com/myimage.png"))
        let mocks = [Mock(url: imageURL, result: .failure(APIError.unexpectedResponse))]
        mocks.forEach { RequestMocking.add(mock: $0) }
        
        let exp = XCTestExpectation(description: "Completion")
        sut.load(imageURL: imageURL).sinkToResult { result in
            result.assertFailure(APIError.unexpectedResponse.localizedDescription)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }

    func test_loadImage_cachedSuccess() throws {
        let imageURL = try XCTUnwrap(URL(string: "https://image.service.com/myimage.png"))
        let responseData = try XCTUnwrap(testImage.pngData())
        
        let networkMock = Mock(url: imageURL, result: .success(responseData))
        RequestMocking.add(mock: networkMock)
        
        let expFirstLoad = XCTestExpectation(description: "First Load Completion")
        sut.load(imageURL: imageURL).sinkToResult { result in
            expFirstLoad.fulfill()
        }.store(in: &subscriptions)
        wait(for: [expFirstLoad], timeout: 2)
        
        RequestMocking.removeAllMocks()
        
        let expCachedLoad = XCTestExpectation(description: "Cached Load Completion")
        sut.load(imageURL: imageURL).sinkToResult { result in
            expCachedLoad.fulfill()
        }.store(in: &subscriptions)
        wait(for: [expCachedLoad], timeout: 2)
    }

    func test_loadImage_imageDeserializationFailure() throws {
        let imageURL = try XCTUnwrap(URL(string: "https://image.service.com/myimage.png"))
        let responseData = Data() // Empty data to intentionally cause deserialization failure

        let networkMock = Mock(url: imageURL, result: .success(responseData))
        RequestMocking.add(mock: networkMock)
        
        let exp = XCTestExpectation(description: "Completion")
        sut.load(imageURL: imageURL).sinkToResult { result in
            result.assertFailure(APIError.imageDeserialization.localizedDescription)
            exp.fulfill()
        }.store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }


}

// MARK: - UI

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: size, format: format).image { rendererContext in
            setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
