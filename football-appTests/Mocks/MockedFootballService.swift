//
//  MockedFootballService.swift
//  football-appTests
//
//  Created by James on 12/01/2024.
//

import Foundation
import Combine
@testable import football_app

final class MockedFootballService: FootballService {
    var allTeam: [FootballTeam] = [FootballTeam]()
    var allMatch: [FootballMatch] = [FootballMatch]()

    func getAllTeam() -> AnyPublisher<[FootballTeam], Error> {
        guard !allTeam.isEmpty else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        return Just<[FootballTeam]>.withErrorType(allTeam, Error.self).eraseToAnyPublisher()
    }

    func getAllMatch() -> AnyPublisher<[FootballMatch], Error> {
        guard !allMatch.isEmpty else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        return Just<[FootballMatch]>.withErrorType(allMatch, Error.self).eraseToAnyPublisher()
    }

    func getUpcomingMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error> {
        Fail(error: APIError.invalidURL).eraseToAnyPublisher()
    }
    
    func getPreviousMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error> {
        Fail(error: APIError.invalidURL).eraseToAnyPublisher()
    }
    
    func getMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error> {
        Fail(error: APIError.invalidURL).eraseToAnyPublisher()
    }
}
