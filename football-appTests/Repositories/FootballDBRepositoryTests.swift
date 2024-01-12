//
//  FootballDBRepositoryTests.swift
//  football-appTests
//
//  Created by James on 12/01/2024.
//

import XCTest
import Combine
@testable import football_app

final class FootballDBRepositoryTests: XCTestCase {
    var mockedStore: MockedPersistentStore!
    var sut: FootballDBRepository!
    var cancelBag: CancelBag = CancelBag()

    override func tearDown() {
        cancelBag = CancelBag()
        sut = nil
        mockedStore = nil
    }

    override func setUp() {
        mockedStore = MockedPersistentStore()
        sut = RealFootballDBRepository(persistenceStore: mockedStore)
        mockedStore.verify()
    }

    func test_hasLoadedTeams() {
        mockedStore.actions = .init(expected: [
            .count,
            .count
        ])
        let exp = XCTestExpectation(description: #function)
        mockedStore.countResult = 0
        sut.hasLoadedTeams()
            .flatMap { value -> AnyPublisher<Bool, Error> in
                XCTAssertFalse(value)
                self.mockedStore.countResult = 10
                return self.sut.hasLoadedTeams()
            }
            .sinkToResult { result in
                result.assertSuccess(value: true)
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 0.5)
    }

    func test_hasLoadedMatches() {
        mockedStore.actions = .init(expected: [
            .count,
            .count
        ])
        let exp = XCTestExpectation(description: #function)
        mockedStore.countResult = 0
        sut.hasLoadedMatches()
            .flatMap { value -> AnyPublisher<Bool, Error> in
                XCTAssertFalse(value)
                self.mockedStore.countResult = 10
                return self.sut.hasLoadedMatches()
            }
            .sinkToResult { result in
                result.assertSuccess(value: true)
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 0.5)
    }

    func test_storeAllTeam() {
        let teams = FootballTeam.mockedData
        mockedStore.actions = .init(expected: [
            .update(.init(inserted: teams.count, updated: 0, deleted: 0))
        ])
        let exp = XCTestExpectation(description: #function)
        sut.store(teams: teams)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 0.5)
    }

    func test_storeAllMatch() {
        let allMatches = FootballMatch.mockedData
        let matches: [FootballMatch] = allMatches.matches.previous + allMatches.matches.upcoming
        mockedStore.actions = .init(expected: [
            .update(.init(inserted: matches.count, updated: 0, deleted: 0))
        ])
        let exp = XCTestExpectation(description: #function)
        sut.store(allMatch: allMatches)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 0.5)
    }

    func test_fetchTeamDetails() throws {
        let details = FootballTeam.mockedData.first!
        mockedStore.actions = .init(expected: [
            .fetchAllTeam(.init(inserted: 0, updated: 0, deleted: 0))
        ])
        try mockedStore.preloadData {
            details.store(in: $0)
        }
        let exp = XCTestExpectation(description: #function)
        sut.teamDetail(for: details)
            .sinkToResult { result in
                result.assertSuccess(value: details)
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 0.5)
    }
}
