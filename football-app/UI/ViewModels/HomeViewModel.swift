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

    func transform(input searchText: AnyPublisher<String, Error>) -> HomeViewModelOutput
}

protocol MatchesViewModel {
    func getLogo(of team: String?) -> AnyPublisher<String?, Error>
}

struct HomeViewModelOutput {
    let matches: AnyPublisher<[FootballMatch], Error>
    let teames: AnyPublisher<[FootballTeam], Error>
}

class RealHomeViewModel: HomeViewModel {
    func transform(input searchText: AnyPublisher<String, Error>) -> HomeViewModelOutput {
        let matches = searchText
            .debounce(for: .seconds(0.01), scheduler: RunLoop.main)
            .combineLatest(footballService.getAllMatch())
            .map { searchText, matches -> [FootballMatch] in
                guard !searchText.isEmpty else {
                    return matches
                }
                return matches.filter { ($0.away?.contains(searchText) ?? false) || (($0.home?.contains(searchText) ?? false))}
            }
            .extractUnderlyingError()
            .eraseToAnyPublisher()
    
        let teames = searchText
            .debounce(for: .seconds(0.01), scheduler: RunLoop.main)
            .combineLatest(footballService.getAllTeam())
            .map { searchText, teames -> [FootballTeam] in
                guard !searchText.isEmpty else {
                    return teames
                }
                return teames.filter { $0.name?.contains(searchText) ?? false}
            }
            .extractUnderlyingError()
            .eraseToAnyPublisher()

        return HomeViewModelOutput(matches: matches, teames: teames)
    }

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
