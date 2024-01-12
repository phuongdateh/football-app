//
//  Team.swift
//  football-app
//
//  Created by James on 04/01/2024.
//

import Foundation
import CoreData

// MARK: - Model
struct FootballTeam: Codable, Equatable, Hashable {
    let id: String
    let name: String?
    let logo: String?

    init(id: String,
         name: String?,
         logo: String?) {
        self.id = id
        self.name = name
        self.logo = logo
    }
}

struct FootballAllTeam: Codable {
    let teams: [FootballTeam]
}

// MARK: - Models+CoreData
extension FootballTeamMO: ManagedEntity {}
extension FootballTeam {
    @discardableResult
    func store(in context: NSManagedObjectContext) -> FootballTeamMO? {
        guard let newObject = FootballTeamMO.insertNew(in: context) else {
            return nil
        }
        newObject.name = name
        newObject.logo = logo
        return newObject
    }

    init?(managedObject: FootballTeamMO) {
        self.init(
            id: "",
            name: managedObject.name,
            logo: managedObject.logo)
    }
}

extension FootballMatch {
    @discardableResult
    func store(in context: NSManagedObjectContext) -> FootballMatchMO? {
        guard let newObject = FootballMatchMO.insertNew(in: context) else {
            return nil
        }
        newObject.away = away
        newObject.home = home
        newObject.matchDescription = description
        newObject.winner = winner
        newObject.highlights = highlights
        newObject.date = date
        return newObject
    }

    init?(managedObject: FootballMatchMO) {
        self.init(date: managedObject.date,
                  description: managedObject.matchDescription, 
                  home: managedObject.home,
                  away: managedObject.away,
                  winner: managedObject.winner,
                  highlights: managedObject.highlights)
    }
}
