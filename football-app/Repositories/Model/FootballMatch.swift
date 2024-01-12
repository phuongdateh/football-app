//
//  Match.swift
//  football-app
//
//  Created by James on 04/01/2024.
//

import Foundation

struct FootballMatch: Codable {
    let date: String?
    let description: String?
    let home: String?
    let away: String?
    let winner: String?
    let highlights: String?
}

extension FootballMatch: Hashable {}

extension FootballMatch {
    private var rawDate: Date {
        guard let date else {
            return Date()
        }
        return DateFormatter.defaultFormatter.date(from: date) ?? Date()
    }

    func hourOfMatch() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: rawDate)
    }

    func dateOfMatch() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM"
        return formatter.string(from: rawDate)
    }

    func statuOfMatch() -> NSAttributedString {
        guard let winner else {
            return NSAttributedString(string: "VS")
        }
        if winner == away {
            return NSAttributedString(string: "1 - 0")
        }
        return NSAttributedString(string: "0 - 1")
    }
}

struct FootballMatches: Codable {
    let previous: [FootballMatch]
    let upcoming: [FootballMatch]
}

struct FootballAllMatches: Codable {
    let matches: FootballMatches
}

// MARK: - Models+CoreData
extension FootballMatchMO: ManagedEntity {}

extension String {
    func attributedString() -> NSAttributedString {
        NSAttributedString(string: self)
    }
}

extension DateFormatter {
    static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_SG")
        formatter.timeZone = TimeZone.current
        return formatter
    }()

}
