//
//  HomeViewModel.swift
//  football-app
//
//  Created by James on 11/01/2024.
//

import Foundation
import Combine

protocol HomeViewModel: MatchesViewModel {
    func getAllTeam() -> AnyPublisher<[FootballTeam], Error>
    func getAllMatch() -> AnyPublisher<[FootballMatch], Error>
}

protocol MatchesViewModel {
    func getLogo(of team: String?) -> AnyPublisher<String?, Error>
}

class RealHomeViewModel: HomeViewModel {
    let footballService: FootballService
    
    init(footballService: FootballService = RealFootballService()) {
        self.footballService = footballService
    }

    func getAllTeam() -> AnyPublisher<[FootballTeam], Error> {
        footballService.getAllTeam()
    }

    func getAllMatch() -> AnyPublisher<[FootballMatch], Error> {
        footballService.getAllMatch()
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
}
