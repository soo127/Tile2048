//
//  BoardFeature.swift
//  Tile2048
//
//  Created by 이상수 on 10/5/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BoardFeature {
    @ObservableState
    struct State: Equatable {
        var board: Board
        var score: Int = 0
        var high: Int = 0
    }

    enum Action {
        case swiped(Direction)
        case addRandomTile
        case tileAdded(row: Int, col: Int, value: Int)
        case onAppear
        case resetGame
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .swiped(direction):
                let result = BoardLogic.move(state.board, direction: direction)
                state.board = result.board
                state.score += result.scoreDelta
                return .run { send in
                    try await Task.sleep(for: .milliseconds(100))
                    await send(.addRandomTile)
                }

            case .addRandomTile:
                let empties = BoardLogic.emptyPositions(state.board)
                guard !empties.isEmpty else { return .none }
                let index = Int.random(in: 0..<empties.count)
                let pos = empties[index]
                return .send(.tileAdded(row: pos.row, col: pos.col, value: 2))

            case let .tileAdded(row, col, value):
                state.board.cells[row][col] = value
                return .none

            case .onAppear:
                state.high = HighScore.load(size: state.board.size)
                let empties = BoardLogic.emptyPositions(state.board)
                if empties.count == state.board.size * state.board.size {
                    return .send(.addRandomTile)
                }
                return .none

            case .resetGame:
                HighScore.updateIfHigher(state.score, size: state.board.size)
                state.high = HighScore.load(size: state.board.size)
                state.board = Board(size: state.board.size)
                state.score = 0
                return .send(.addRandomTile)
            }
        }
    }
}

extension BoardFeature.State {
    static let mock = BoardFeature.State(
        board: Board(size: 4),
        score: 0
    )
}

extension BoardFeature {
    enum Constants {
        static let sizes = [4, 5, 6]
    }
}
