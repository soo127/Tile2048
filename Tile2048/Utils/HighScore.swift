//
//  HighScore.swift
//  Tile2048
//
//  Created by Assistant on 10/22/25.
//

import Foundation

enum HighScore {
    static func load(size: Int) -> Int {
        UserDefaults.standard.integer(forKey: Constants.key(size))
    }

    static func updateIfHigher(_ newScore: Int, size: Int) {
        let current = load(size: size)
        if newScore > current {
            UserDefaults.standard.set(newScore, forKey: Constants.key(size))
        }
    }
}

extension HighScore {
    fileprivate enum Constants {
        static func key(_ size: Int) -> String {
            "high_score_key_\(size)"
        }
    }
}
