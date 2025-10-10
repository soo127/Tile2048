//
//  GridFeature.swift
//  Tile2048
//
//  Created by 이상수 on 10/5/25.
//

import ComposableArchitecture

@Reducer
struct GridFeature {
    @ObservableState
    struct State: Equatable {
        var board = Board(size: 4)
    }

    enum Action {
        case swipeUp
        case swipeDown
        case swipeLeft
        case swipeRight
        case addRandomTile
        case tileAdded(row: Int, col: Int, value: Int)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .swipeUp:
                state.board = BoardLogic.move(state.board, direction: .up)
                return .send(.addRandomTile)

            case .swipeDown:
                state.board = BoardLogic.move(state.board, direction: .down)
                return .send(.addRandomTile)

            case .swipeLeft:
                state.board = BoardLogic.move(state.board, direction: .left)
                return .send(.addRandomTile)

            case .swipeRight:
                state.board = BoardLogic.move(state.board, direction: .right)
                return .send(.addRandomTile)

            case .addRandomTile:
                let emptyPositions = BoardLogic.findEmptyPositions(state.board)
                guard !emptyPositions.isEmpty else { return .none }

                let randomIndex = Int.random(in: 0..<emptyPositions.count)
                let position = emptyPositions[randomIndex]

                return .send(.tileAdded(row: position.row, col: position.col, value: 2))

            case let .tileAdded(row, col, value):
                state.board.cells[row][col] = value
                return .none
            }
        }
    }
}

enum Direction {
    case up, down, left, right
}
