//
//  HighScore.swift
//  Tile2048
//
//  Created by Assistant on 10/22/25.
//

import Foundation

enum HighScore {
    static func load() -> Int {
        UserDefaults.standard.integer(forKey: Constants.key)
    }

    static func updateIfHigher(_ newScore: Int) {
        let current = load()
        if newScore > current {
            UserDefaults.standard.set(newScore, forKey: Constants.key)
        }
    }
}

extension HighScore {
    fileprivate enum Constants {
        static let key = "high_score_key"
    }
}
