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
    }

    enum Action {
        case swipe(CGSize)
        case addRandomTile
        case tileAdded(row: Int, col: Int, value: Int)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .swipe(translation):
                let direction = BoardLogic.determineDirection(translation)
                state.board = BoardLogic.move(state.board, direction: direction)
                return .send(.addRandomTile)

            case .addRandomTile:
                guard let pos = BoardLogic.findEmptyPosition(state.board) else {
                    return .none
                }
                return .send(.tileAdded(row: pos.row, col: pos.col, value: 2))

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
