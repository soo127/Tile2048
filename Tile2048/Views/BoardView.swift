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
        board
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { gesture in
                        handleSwipe(gesture)
                    }
            )
    }

    private var board: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 4)
        ) {
            ForEach(0..<16) {
                TileView(value: store.board.cells[$0 / 4][$0 % 4])
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(8)
    }

    private func handleSwipe(_ gesture: DragGesture.Value) {
        let horizontal = abs(gesture.translation.width)
        let vertical = abs(gesture.translation.height)

        if horizontal > vertical {
            if gesture.translation.width > 0 {
                store.send(.swipeRight)
            } else {
                store.send(.swipeLeft)
            }
        } else {
            if gesture.translation.height > 0 {
                store.send(.swipeDown)
            } else {
                store.send(.swipeUp)
            }
        }
    }

}
