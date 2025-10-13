//
//  GridView.swift
//  Tile2048
//
//  Created by 이상수 on 10/5/25.
//

import SwiftUI
import ComposableArchitecture

struct GridView: View {
    let store: StoreOf<GridFeature>

    var body: some View {
        VStack {
            board
            HStack {
                Button("up") { store.send(.swipeUp) }
                Button("down") { store.send(.swipeDown) }
                Button("left") { store.send(.swipeLeft) }
                Button("right") { store.send(.swipeRight) }
            }
        }
    }

    private var board: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 4)
        ) {
            boardCells
        }
        .padding(8)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(8)
    }

    private var boardCells: some View {
        ForEach(0..<4) { row in
            ForEach(0..<4) { col in
                TileView(value: store.board.cells[row][col])
            }
        }
    }

}
