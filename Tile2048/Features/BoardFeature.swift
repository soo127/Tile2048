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
    }

    enum Action {
        case swiped(Direction)
        case addRandomTile
        case tileAdded(row: Int, col: Int, value: Int)
        case onAppear
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
                @Dependency(\.randomClient) var randomClient
                let index = randomClient.randomIndex(empties.count)
                let pos = empties[index]
                return .send(.tileAdded(row: pos.row, col: pos.col, value: 2))

            case let .tileAdded(row, col, value):
                state.board.cells[row][col] = value
                return .none

            case .onAppear:
                let empties = BoardLogic.emptyPositions(state.board)
                if empties.count == state.board.size * state.board.size {
                    return .send(.addRandomTile)
                }
                return .none
            }
        }
    }
}

extension BoardFeature.State {
    static let mock = BoardFeature.State(
        board: Board(size: 4),
        score: 1234
    )
}
