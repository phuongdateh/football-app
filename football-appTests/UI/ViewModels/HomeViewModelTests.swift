//
//  HomeViewModelTests.swift
//  football-appTests
//
//  Created by James on 12/01/2024.
//

import XCTest
import Combine
@testable import football_app

final class HomeViewModelTests: XCTestCase {
    private var mockFootballService: MockedFootballService!
    private var sut: HomeViewModel!
    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        mockFootballService = MockedFootballService()
        subscriptions = Set<AnyCancellable>()
        sut = RealHomeViewModel(footballService: mockFootballService)
    }

    func test_allTeam() {
        mockFootballService.allTeam = FootballTeam.mockedData

        let exp = XCTestExpectation(description: "Completion")
        sut.getAllTeam()
            .sinkToResult { result in
                switch result {
                case .success(let actualList):
                    XCTAssertFalse(actualList.isEmpty)
                    exp.fulfill()
                default:
                    break
                }
            }.store(in: &subscriptions)
        wait(for: [exp])
    }

    func test_allMatch() {
        mockFootballService.allMatch = FootballAllMatches.mockedData.matches.upcoming
        
        let exp = XCTestExpectation(description: "Completion")
        sut.getAllMatch()
            .sinkToResult { result in
                switch result {
                case .success(let actualList):
                    XCTAssertFalse(actualList.isEmpty)
                    exp.fulfill()
                default:
                    break
                }
            }.store(in: &subscriptions)
        wait(for: [exp])
    }

    func test_getLogoOfTeam() {
        mockFootballService.allTeam = FootballTeam.mockedData
        let urlExpected: String? = "https://logo"

        let exp = XCTestExpectation(description: "Completion")
        sut.getLogo(of: "MU")
            .sinkToResult { result in
                switch result {
                case .success(let actualURL):
                    XCTAssertEqual(actualURL, urlExpected)
                    exp.fulfill()
                default:
                    break
                }
            }.store(in: &subscriptions)
        wait(for: [exp])
    }
}
