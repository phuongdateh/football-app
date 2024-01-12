//
//  TeamDetailView.swift
//  football-app
//
//  Created by James on 11/01/2024.
//

import Foundation
import Combine

protocol TeamDetailViewModel: MatchesViewModel {
    func getUpcomingMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error>
    func getPreviousMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error>
}

class RealTeamDetailViewModel: TeamDetailViewModel {
    let footballService: FootballService
    
    init(footballService: FootballService = RealFootballService()) {
        self.footballService = footballService
    }

    func getLogo(of team: String?) -> AnyPublisher<String?, Error> {
        footballService
            .getAllTeam()
            .map { list -> String? in
                return list.filter { $0.name == team }.first?.logo
            }
            .extractUnderlyingError()
            .eraseToAnyPublisher()
    }

    func getPreviousMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error> {
        footballService.getPreviousMatches(of: team)
    }

    func getUpcomingMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error> {
        footballService.getUpcomingMatches(of: team)
    }
}
