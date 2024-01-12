//
//  NetworkingHelpers.swift
//  football-app
//
//  Created by James on 08/01/2024.
//

import Foundation
import Combine

extension Just where Output == Void {
    static func withErrorType<E>(_ errorType: E.Type) -> AnyPublisher<Void, E> {
        return withErrorType((), E.self)
    }
}

extension Just {
    static func withErrorType<Error>(_ value: Output, _ errorType: Error.Type) -> AnyPublisher<Output, Error> {
        return Just(value)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }
    
    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            ($0.underlyingError as? Failure) ?? $0
        }
    }
    
    /// Holds the downstream delivery of output until the specified time interval passed after the subscription
    /// Does not hold the output if it arrives later than the time threshold
    ///
    /// - Parameters:
    ///   - interval: The minimum time interval that should elapse after the subscription.
    /// - Returns: A publisher that optionally delays delivery of elements to the downstream receiver.
    
    func ensureTimeSpan(_ interval: TimeInterval) -> AnyPublisher<Output, Failure> {
        let timer = Just<Void>(())
            .delay(for: .seconds(interval), scheduler: RunLoop.main)
            .setFailureType(to: Failure.self)
        return zip(timer)
            .map { $0.0 }
            .eraseToAnyPublisher()
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
            // "The Internet connection appears to be offline."
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case unexpectedResponse
    case httpCode(HTTPCode)
    case imageDeserialization
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case let (.requestFailed(lhsError), .requestFailed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.unexpectedResponse, .unexpectedResponse):
            return true
        default:
            return false
        }
    }
}
