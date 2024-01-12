//
//  TestHelpers.swift
//  football-appTests
//
//  Created by James on 11/01/2024.
//

import Foundation
import XCTest
import Combine

// MARK: - Result

extension Result where Success: Equatable {
    func assertSuccess(value: Success, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(resultValue):
            XCTAssertEqual(resultValue, value, file: file, line: line)
        case let .failure(error):
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}

extension Result where Success == Void {
    func assertSuccess(file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .failure(error):
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        case .success:
            break
        }
    }
}

extension Result {
    func assertFailure(_ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(value):
            XCTFail("Unexpected success: \(value)", file: file, line: line)
        case let .failure(error):
            if let message = message {
                XCTAssertEqual(error.localizedDescription, message, file: file, line: line)
            }
        }
    }
}

extension Publisher {
    func publish() -> AnyPublisher<Output, Failure> {
        delay(for: .milliseconds(10), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

