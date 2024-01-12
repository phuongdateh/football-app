//
//  MockedWebRepositories.swift
//  football-appTests
//
//  Created by James on 11/01/2024.
//

import XCTest
import Combine
@testable import football_app

class TestWebRepository: WebRepository {
    let session: URLSession = .mockedResponsesOnly
    let baseURL = "https://test.com"
    let bgQueue = DispatchQueue(label: "test")
}
