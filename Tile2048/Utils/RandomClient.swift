//
//  RandomClient.swift
//  Tile2048
//
//  Created by Assistant on 10/15/25.
//

import Foundation
import ComposableArchitecture

struct RandomClient {
    var randomIndex: (_ upperBoundExclusive: Int) -> Int
}

extension RandomClient: DependencyKey {
    static var liveValue: RandomClient {
        RandomClient { upperBound in
            Int.random(in: 0..<upperBound)
        }
    }

    static var testValue: RandomClient { RandomClient { _ in 0 } }

    static var previewValue: RandomClient { liveValue }
}

extension DependencyValues {
    var randomClient: RandomClient {
        get { self[RandomClient.self] }
        set { self[RandomClient.self] = newValue }
    }
}
