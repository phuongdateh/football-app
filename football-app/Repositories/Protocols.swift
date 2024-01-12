//
//  Protocols.swift
//  football-app
//
//  Created by James on 09/01/2024.
//

import Combine
import UIKit

protocol FootballDBRepository {
    // Checking teams has been saved or not
    func hasLoadedTeams() -> AnyPublisher<Bool, Error>
    // Checking matches has been saved or not
    func hasLoadedMatches() -> AnyPublisher<Bool, Error>
    // Store team on local
    func store(teams: [FootballTeam]) -> AnyPublisher<Void, Error>
    // Store all matches on local
    func store(allMatch: FootballAllMatches) -> AnyPublisher<Void, Error>
    // Get an team detail
    func teamDetail(for team: FootballTeam) -> AnyPublisher<FootballTeam?, Error>
    // Get all teams
    func allTeam() -> AnyPublisher<[FootballTeam], Error>
    // Get all match
    func allMatch() -> AnyPublisher<[FootballMatch], Error>
}

protocol FootballWebRepository: WebRepository {
    func loadAllTeam() -> AnyPublisher<FootballAllTeam, Error>
    func loadAllMatch() -> AnyPublisher<FootballAllMatches, Error>
}

protocol ImageWebRepository: WebRepository {
    func load(imageURL: URL) -> AnyPublisher<UIImage, Error>
}

// MARK: - Services
protocol ImagesService {
    func load(imageURL: URL) -> AnyPublisher<UIImage, Error>
}

protocol FootballService {
    func getAllTeam() ->  AnyPublisher<[FootballTeam], Error>
    func getAllMatch() -> AnyPublisher<[FootballMatch], Error>
    func getUpcomingMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error>
    func getPreviousMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error>
    func getMatches(of team: FootballTeam) -> AnyPublisher<[FootballMatch], Error>
}
