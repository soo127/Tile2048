//
//  Board.swift
//  Tile2048
//
//  Created by 이상수 on 10/7/25.
//

import Foundation

struct Board: Equatable {
    var cells: [[Int?]]
    var size: Int

    init(size: Int) {
        self.size = size
        cells = Array(repeating: Array(repeating: nil, count: size), count: size)
    }
}
