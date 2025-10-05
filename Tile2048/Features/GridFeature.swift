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
        var score = 0
        var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    }

    enum Action {
        case swipeUp, swipeDown, swipeLeft, swipeRight
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .swipeUp:
                state.board = Array(repeating: Array(repeating: 1, count: 4), count: 4)
                return .none
            case .swipeDown:
                state.board = Array(repeating: Array(repeating: 2, count: 4), count: 4)
                return .none
            case .swipeLeft:
                state.board = Array(repeating: Array(repeating: 3, count: 4), count: 4)
                return .none
            case .swipeRight:
                state.board = Array(repeating: Array(repeating: 4, count: 4), count: 4)
                return .none
            }
        }
    }
}
