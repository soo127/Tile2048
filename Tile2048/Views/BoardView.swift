//
//  BoardView.swift
//  Tile2048
//
//  Created by 이상수 on 10/5/25.
//

import SwiftUI
import ComposableArchitecture

struct BoardView: View {

    let store: StoreOf<BoardFeature>

    var body: some View {
        board(size: store.board.size)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { gesture in
                        store.send(.swipe(gesture.translation))
                    }
            )
    }

    private func board(size: Int) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: size)
        ) {
            ForEach(0..<(size * size), id: \.self) {
                TileView(value: store.board.cells[$0 / size][$0 % size])
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(8)
    }

}
