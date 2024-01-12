//
//  MockData.swift
//  football-appTests
//
//  Created by James on 12/01/2024.
//

import Foundation
import XCTest
@testable import football_app

extension FootballTeam {
    static let mockedData: [FootballTeam] = {
        [FootballTeam(id: "", name: "MU", logo: "https://logo")]
    }()
}

extension FootballMatch {
    static let mockedData: FootballAllMatches = {
        return try! JSONDecoder().decode(FootballAllMatches.self, from: allMatchData)
    }()
}

extension FootballAllMatches {
    static let mockedData: FootballAllMatches = {
        return try! JSONDecoder().decode(FootballAllMatches.self, from: allMatchData)
    }()
}

extension FootballAllTeam {
    static let mockedData: FootballAllTeam = {
        try! JSONDecoder().decode(FootballAllTeam.self, from: allTeamData)
    }()
}

// MARK: - Equatable
extension FootballAllMatches: Equatable {
    public static func == (lhs: FootballAllMatches, rhs: FootballAllMatches) -> Bool {
        return lhs.matches == rhs.matches
    }
}

extension FootballMatches: Equatable {
    public static func == (lhs: FootballMatches, rhs: FootballMatches) -> Bool {
        return lhs.previous == rhs.previous && lhs.upcoming == rhs.upcoming
    }
}

extension FootballAllTeam: Equatable {
    public static func == (lhs: FootballAllTeam, rhs: FootballAllTeam) -> Bool {
        return lhs.teams == rhs.teams
    }
}

// MARK: - JSONData
fileprivate let allTeamData: Data = """
{
  "teams": [
    {
      "id": "f784f104-eb8b-11ec-8ea0-0242ac120002",
      "name": "Team Hungry Sharks",
      "logo": "https://tstzj.s3.amazonaws.com/sharks.png"
    },
    {
      "id": "22e4fd58-eb8c-11ec-8ea0-0242ac120002",
      "name": "Team Growling Tigers",
      "logo": "https://tstzj.s3.amazonaws.com/tiger.png"
    },
    {
      "id": "09294c60-eb8d-11ec-8ea0-0242ac120002",
      "name": "Team Royal Knights",
      "logo": "https://tstzj.s3.amazonaws.com/knights.png"
    }
  ]
}
""".data(using: .utf8) ?? Data()

fileprivate let allMatchData: Data = """
{
  "matches": {
    "previous": [
      {
        "date": "2022-06-13T18:00:00.000Z",
        "description": "Team Growling Tigers vs. Team Chill Elephants",
        "home": "Team Growling Tigers",
        "away": "Team Chill Elephants",
        "winner": "Team Chill Elephants",
        "highlights": "https://tstzj.s3.amazonaws.com/highlights.mp4"
      },
      {
        "date": "2022-06-13T18:00:00.000Z",
        "description": "Team Royal Knights vs. Team Red Dragons",
        "home": "Team Royal Knights",
        "away": "Team Red Dragons",
        "winner": "Team Royal Knights",
        "highlights": "https://tstzj.s3.amazonaws.com/highlights.mp4"
      }
    ],
    "upcoming": [
      {
        "date": "2024-09-05T18:00:00.000Z",
        "description": "Team Angry Pandas vs. Team Growling Tigers",
        "home": "Team Angry Pandas",
        "away": "Team Growling Tigers"
      },
      {
        "date": "2024-09-06T18:00:00.000Z",
        "description": "Team Fiery Phoenix vs. Team Hungry Sharks",
        "home": "Team Fiery Phoenix ",
        "away": "Team Hungry Sharks"
      }
    ]
  }
}
""".data(using: .utf8) ?? Data()
