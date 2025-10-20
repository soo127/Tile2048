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
        VStack {
            scoreBoard
            board(size: store.board.size)
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { gesture in
                            let direction = BoardLogic.determineDirection(gesture.translation)
                            store.send(.swiped(direction))
                        }
                )
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    private var scoreBoard: some View {
        VStack(spacing: 4) {
            Text("SCORE")
                .font(.caption)
                .foregroundColor(.primary)

            Text("\(store.score)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(width: 100, height: 70)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(8)
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
