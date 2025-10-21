//
//  Tile2048App.swift
//  Tile2048
//
//  Created by 이상수 on 10/5/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct Tile2048App: App {
    let gameStore = Store(initialState: BoardFeature.State(board: Board(size: 4))) {
        BoardFeature()
    }
    var body: some Scene {
        WindowGroup {
            GameStartView(store: gameStore)
        }
    }
}
