//
//  FootballWebRepository.swift
//  football-app
//
//  Created by James on 09/01/2024.
//

import Foundation
import Combine

struct RealFootballWebRepository: FootballWebRepository {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession = .defaultConfigured(),
         baseURL: String = "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com") {
        self.session = session
        self.baseURL = baseURL
    }

    func loadAllMatch() -> AnyPublisher<FootballAllMatches, Error> {
        call(endpoint: API.allMatch)
    }

    func loadAllTeam() -> AnyPublisher<FootballAllTeam, Error> {
        call(endpoint: API.allTeam)
    }
}

extension RealFootballWebRepository {
    enum API: APICall {
        var path: String {
            switch self {
            case .allTeam:
                return "/teams"
            case .allMatch:
                return "/teams/matches"
            }
        }

        var method: String {
            "GET"
        }
        
        var headers: [String : String]? {
            ["Accept": "application/json"]
        }
        
        func body() throws -> Data? {
            return nil
        }
        case allMatch
        case allTeam
    }
}

extension URLSession {
    static func defaultConfigured() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
}
