//
//  FootballWebRepositoryTests.swift
//  football-appTests
//
//  Created by James on 12/01/2024.
//

import XCTest
import Combine
@testable import football_app

final class FootballWebRepositoryTests: XCTestCase {
    private var sut: RealFootballWebRepository!
    private var subscriptions = Set<AnyCancellable>()
    
    typealias API = RealFootballWebRepository.API
    typealias Mock = RequestMocking.MockedResponse

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = RealFootballWebRepository(session: .mockedResponsesOnly,
                                        baseURL: "https://testing.com")
    }

    override func tearDown() {
        RequestMocking.removeAllMocks()
    }

    func test_allTeam() throws {
        let data = FootballAllTeam.mockedData
        try mock(.allTeam, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadAllTeam()
            .sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }

    func test_allMath() throws {
        let data = FootballAllMatches.mockedData
        try mock(.allMatch, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadAllMatch()
            .sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }

    // MARK: - Helper
    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
}
