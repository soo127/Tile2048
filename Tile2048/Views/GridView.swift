//
//  GridView.swift
//  Tile2048
//
//  Created by 이상수 on 10/5/25.
//

import SwiftUI
import ComposableArchitecture

struct GridView: View {
    let store: StoreOf<GridFeature>

    var body: some View {
        VStack {
            Button("up") { store.send(.swipeUp) }
            Button("down") { store.send(.swipeDown) }
            Button("left") { store.send(.swipeLeft) }
            Button("right") { store.send(.swipeRight) }
        }
    }
}
