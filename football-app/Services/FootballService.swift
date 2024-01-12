//
//  FootballService.swift
//  football-app
//
//  Created by James on 06/01/2024.
//

import Foundation
import Combine

struct RealFootballService: FootballService {
    let dbRepository: FootballDBRepository
    let webRepository: FootballWebRepository

    init(dbRepository: FootballDBRepository = RealFootballDBRepository(),
         webRepository: FootballWebRepository = RealFootballWebRepository()) {
        self.dbRepository = dbRepository
        self.webRepository = webRepository
    }

    func getUpcomingMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error> {
        Just<[FootballMatch]>
            .withErrorType([], Error.self)
            .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
                dbRepository.hasLoadedTeams()
            }
            .flatMap { hasLoaded in
                guard hasLoaded else {
                    return refreshMatches()
                }
                return Just<Void>.withErrorType(Error.self)
            }
            .flatMap { [dbRepository] in
                dbRepository.allMatch()
            }
            .flatMap { result -> AnyPublisher<[FootballMatch], Error> in
                let upcomingMatches: [FootballMatch] = result.filter { match in
                    guard match.winner == nil else {
                        return false
                    }
                    return match.home == team.name || match.away == team.name
                }
                return Just<[FootballMatch]>.withErrorType(upcomingMatches, Error.self)
            }
            .eraseToAnyPublisher()
    }
    
    func getPreviousMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error> {
        Just<[FootballMatch]>
            .withErrorType([], Error.self)
            .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
                dbRepository.hasLoadedMatches()
            }
            .flatMap { hasLoaded in
                guard hasLoaded else {
                    return refreshMatches()
                }
                return Just<Void>.withErrorType(Error.self)
            }
            .flatMap { [dbRepository] in
                dbRepository.allMatch()
            }
            .flatMap { result -> AnyPublisher<[FootballMatch], Error> in
                let previousMatches: [FootballMatch] = result.filter({ $0.winner != nil && ($0.away == team.name || $0.home == team.name) })
                return Just<[FootballMatch]>.withErrorType(previousMatches, Error.self)
            }
            .eraseToAnyPublisher()
    }
    
    func getMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error> {
        Just<[FootballMatch]>.withErrorType([], Error.self).eraseToAnyPublisher()
    }

    func getAllTeam() ->  AnyPublisher<[FootballTeam], Error> {
        Just<[FootballTeam]>
            .withErrorType([], Error.self)
            .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
                dbRepository.hasLoadedTeams()
            }
            .flatMap { hasLoaded in
                guard hasLoaded else {
                    return refreshTeams()
                }
                return Just<Void>.withErrorType(Error.self)
            }
            .flatMap { [dbRepository] in
                dbRepository.allTeam()
            }
            .eraseToAnyPublisher()
    }

//    func getAllTeam() -> AnyPublisher<LazyList<FootballTeam>, Error> {
//        Just<LazyList<FootballTeam>>
//            .withErrorType(.empty, Error.self)
//            .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
//                dbRepository.hasLoadedTeams()
//            }
//            .flatMap { hasLoaded in
//                guard hasLoaded else {
//                    return refreshTeams()
//                }
//                return Just<Void>.withErrorType(Error.self)
//            }
//            .flatMap { [dbRepository] in
//                dbRepository.allTeam()
//            }
//            .eraseToAnyPublisher()
//    }

    func getAllMatch() -> AnyPublisher<[FootballMatch], Error> {
        Just<[FootballMatch]>
            .withErrorType([FootballMatch](), Error.self)
            .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
                dbRepository.hasLoadedMatches()
            }
            .flatMap { hasLoaded in
                guard hasLoaded else {
                    return refreshMatches()
                }
                return Just<Void>.withErrorType(Error.self)
            }
            .flatMap { [dbRepository] in
                dbRepository.allMatch()
            }
            .eraseToAnyPublisher()
    }

    func refreshTeams() -> AnyPublisher<Void, Error> {
        webRepository
            .loadAllTeam()
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .flatMap { [dbRepository] in
                dbRepository.store(teams: $0.teams)
            }
            .eraseToAnyPublisher()
    }

    func refreshMatches() -> AnyPublisher<Void, Error> {
        webRepository
            .loadAllMatch()
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .flatMap { [dbRepository] in
                dbRepository.store(allMatch: $0)
            }
            .eraseToAnyPublisher()
    }

    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
}

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}

