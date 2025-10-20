//
//  TileColor.swift
//  Tile2048
//
//  Created by 이상수 on 10/20/25.
//

import SwiftUI

enum TileColor {
    static func background(for value: Int?) -> Color {
        guard let value else { return .gray.opacity(0.3) }
        let level = Int(log2(Double(value)))
        return Constants.colorMap[level] ?? Constants.highColor
    }
}

extension TileColor {
    fileprivate enum Constants {
        static let colorMap: [Int: Color] = [
            1: .orange.opacity(0.3),
            2: .orange.opacity(0.5),
            3: .orange.opacity(0.7),
            4: .orange,
            5: .red.opacity(0.7),
            6: .red,
            7: .yellow.opacity(0.7),
            8: .yellow.opacity(0.85),
            9: .yellow,
            10: .green.opacity(0.7),
            11: .green,
            12: .blue.opacity(0.7),
            13: .blue,
            14: .purple.opacity(0.7)
        ]

        static let highColor: Color = .purple
    }
}
