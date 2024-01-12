//
//  FootballDBRepository.swift
//  football-app
//
//  Created by James on 08/01/2024.
//

import CoreData
import Combine

struct RealFootballDBRepository: FootballDBRepository {
    let persistenceStore: PersistentStore

    init(persistenceStore: PersistentStore = CoreDataStack(version: CoreDataStack.Version.actual)) {
        self.persistenceStore = persistenceStore
    }

    func hasLoadedTeams() -> AnyPublisher<Bool, Error> {
        let fetchRequest = FootballTeamMO.justOneTeam()
        return persistenceStore
            .count(fetchRequest)
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }
    
    func hasLoadedMatches() -> AnyPublisher<Bool, Error> {
        let fetchRequest = FootballMatchMO.justOneMatch()
        return persistenceStore
            .count(fetchRequest)
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }

    func store(teams: [FootballTeam]) -> AnyPublisher<Void, Error> {
        persistenceStore.update { context in
            teams.forEach {
                $0.store(in: context)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func store(allMatch: FootballAllMatches) -> AnyPublisher<Void, Error> {
        persistenceStore.update { context in
            let matches = allMatch.matches
            let allMatch = matches.previous + matches.upcoming
            allMatch.forEach { $0.store(in: context) }
        }
        .eraseToAnyPublisher()
    }

    func allTeam() -> AnyPublisher<[FootballTeam], Error> {
        let request: NSFetchRequest = FootballTeamMO.allTeam()
        return persistenceStore.fetch(request) {
            FootballTeam(managedObject: $0)
        }
        .map { Array($0) }
        .eraseToAnyPublisher()
    }

    func allMatch() -> AnyPublisher<[FootballMatch], Error> {
        let request: NSFetchRequest = FootballMatchMO.allMatch()
        return persistenceStore.fetch(request) {
            FootballMatch(managedObject: $0)
        }
        .map { Array($0) }
        .eraseToAnyPublisher()
    }
    
    func teamDetail(for team: FootballTeam) -> AnyPublisher<FootballTeam?, Error> {
        allTeam()
            .map { $0.first(where: { $0.name == team.name }) }
            .eraseToAnyPublisher()
    }
}

extension FootballTeamMO {
    static func justOneTeam() -> NSFetchRequest<FootballTeamMO> {
        let newRequest = newFetchRequest()
        newRequest.fetchLimit = 1
        return newRequest
    }

    static func allTeam(fetchLimit: Int = .max) -> NSFetchRequest<FootballTeamMO> {
        let newRequest = newFetchRequest()
        newRequest.fetchLimit = fetchLimit
        return newRequest
    }
}

extension FootballMatchMO {
    static func justOneMatch() -> NSFetchRequest<FootballMatchMO> {
        let newRequest = newFetchRequest()
        newRequest.fetchLimit = 1
        return newRequest
    }

    static func allMatch(fetchLimit: Int = .max) -> NSFetchRequest<FootballMatchMO> {
        let newRequest = newFetchRequest()
        newRequest.fetchLimit = fetchLimit
        return newRequest
    }
}
