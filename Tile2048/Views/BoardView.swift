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
        VStack(spacing: 15) {
            head
            buttons
            board
        }
        .onAppear {
            store.send(.onAppear)
        }
        .padding(.horizontal)
    }

    private var head: some View {
        HStack {
            title
            Spacer()
            score
        }
    }

    private var title: some View {
        Text("2048")
            .font(.system(size: 50, weight: .semibold))
            .foregroundStyle(.primary.opacity(0.7))
    }

    private var score: some View {
        VStack(spacing: 4) {
            Text("SCORE")
                .font(.caption)
                .foregroundColor(.primary)

            Text("\(store.score)")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
                .minimumScaleFactor(0.5)
        }
        .frame(width: 90, height: 60)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(8)
    }

    private var buttons: some View {
        HStack {
            homeButton
            Spacer()
            resetButton
        }
    }

    private var homeButton: some View {
        Button {
            print("home")
        } label: {
            Image(systemName: "house")
                .resizable()
                .frame(width: 30, height: 30)
                .tint(.white)
                .padding(7)
                .background(.gray.opacity(0.9))
                .cornerRadius(8)
        }
    }

    private var resetButton: some View {
        Button {
            store.send(.resetGame)
        } label: {
            Image(systemName: "arrow.clockwise")
                .resizable()
                .frame(width: 30, height: 30)
                .tint(.white)
                .padding(7)
                .background(.gray.opacity(0.9))
                .cornerRadius(8)
        }
    }

    private var board: some View {
        board(size: store.board.size)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { gesture in
                        let direction = BoardLogic.determineDirection(gesture.translation)
                        store.send(.swiped(direction))
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
        .background(.gray.opacity(0.3))
        .cornerRadius(8)
    }
}

#Preview {
    BoardView(store: Store(initialState: .mock) {
        BoardFeature()
    })
}
