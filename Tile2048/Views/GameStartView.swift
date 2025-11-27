//
//  GameStartView.swift
//  Tile2048
//
//  Created by 이상수 on 10/20/25.
//

import SwiftUI
import ComposableArchitecture

struct GameStartView: View {
    @State private var selectedIdx = 0
    private let sizes = BoardFeature.Constants.sizes

    var body: some View {
        NavigationStack {
            ZStack {
                background
                contents
            }
        }
    }

    private var contents: some View {
        VStack {
            Spacer()
            title
            Spacer()
            sizePicker
            Spacer()
            startButton
            Spacer()
        }
    }

    private var background: some View {
        LinearGradient(
            colors: [.orange.opacity(0.8), .yellow.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var title: some View {
        Text("Tile 2048")
            .font(.system(size: 48, weight: .bold))
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 2)
    }

    private var sizePicker: some View {
        HStack {
            leftArrow
            Spacer()
            currentSize
            Spacer()
            rightArrow
        }
        .padding(.horizontal)
    }

    private var leftArrow: some View {
        sizeChangeButton(direction: -1, imageName: "arrowtriangle.backward.fill")
    }

    private var currentSize: some View {
        Text("\(sizes[selectedIdx])x\(sizes[selectedIdx])")
            .font(.system(size: 40, weight: .bold))
    }

    private var rightArrow: some View {
        sizeChangeButton(direction: 1, imageName: "arrowtriangle.forward.fill")
    }

    private func sizeChangeButton(direction: Int, imageName: String) -> some View {
        Button {
            selectedIdx = (selectedIdx + direction + sizes.count) % sizes.count
        } label: {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 40, height: 40)
        }
    }

    private var startButton: some View {
        NavigationLink {
            BoardView(
                store: Store(
                    initialState: BoardFeature.State(board: Board(size: sizes[selectedIdx]))
                ) {
                    BoardFeature()
                }
            )
        } label: {
            Text("START")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 60)
                .padding(.vertical, 16)
                .background(.blue.gradient)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 4)
        }
    }
}
