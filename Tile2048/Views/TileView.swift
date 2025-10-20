//
//  TileView.swift
//  Tile2048
//
//  Created by 이상수 on 10/13/25.
//

import SwiftUI

struct TileView: View {
    let value: Int?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(TileColor.background(for: value))

            if let value {
                Text("\(value)")
                    .font(.title3.bold())
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
