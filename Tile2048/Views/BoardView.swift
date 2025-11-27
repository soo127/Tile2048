//
//  BoardView.swift
//  Tile2048
//
//  Created by 이상수 on 10/5/25.
//

import SwiftUI
import ComposableArchitecture

struct BoardView: View {
    @Bindable var store: StoreOf<BoardFeature>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 15) {
            head
            buttons
            board
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            store.send(.onAppear)
        }
        .padding(.horizontal)
        .sheet(isPresented: $store.gameOver.sending(\.setGameOver)) {
            gameOverModalView(score: store.score)
        }
    }

    private func gameOverModalView(score: Int) -> some View {
        VStack(spacing: 20) {
            Text("GAME OVER")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)

            Text("최종 점수: \(score)")
                .font(.title2)
                .foregroundColor(.primary)
        }
        .padding(40)
    }

    private var head: some View {
        HStack {
            title
            Spacer()
            score
            best
        }
    }

    private var title: some View {
        Text("2048")
            .font(.system(size: 50, weight: .semibold))
            .foregroundStyle(.primary.opacity(0.7))
    }

    private var score: some View {
        scoreBox(title: "SCORE", value: store.score)
    }

    private var best: some View {
        scoreBox(title: "BEST", value: store.high)
    }

    private func scoreBox(title: String, value: Int) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)

            Text("\(value)")
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
            store.send(.resetGame)
            dismiss()
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
            store.send(.addRandomTile)
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
            ForEach(0..<(size * size), id: \.self) { index in
                let row = index / size
                let col = index % size
                TileView(value: store.board.cells[row][col])
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
