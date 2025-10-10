//
//  BoardLogic.swift
//  Tile2048
//
//  Created by 이상수 on 10/10/25.
//

enum BoardLogic {
    static func findEmptyPositions(_ board: Board) -> [(row: Int, col: Int)] {
        var positions: [(row: Int, col: Int)] = []
        for row in 0..<board.size {
            for col in 0..<board.size where board.cells[row][col] == nil {
                positions.append((row, col))
            }
        }
        return positions
    }

    static func move(_ board: Board, direction: Direction) -> Board {
        var newBoard = board

        switch direction {
        case .up:
            for col in 0..<board.size {
                let tiles = (0..<board.size).map { board.cells[$0][col] }
                let merged = merge(tiles, size: board.size)
                for row in 0..<board.size {
                    newBoard.cells[row][col] = merged[row]
                }
            }
        case .down:
            for col in 0..<board.size {
                let tiles = (0..<board.size).reversed().map { board.cells[$0][col] }
                let merged = Array(merge(tiles, size: board.size).reversed())
                for row in 0..<board.size {
                    newBoard.cells[row][col] = merged[row]
                }
            }
        case .left:
            for row in 0..<board.size {
                let tiles = board.cells[row]
                newBoard.cells[row] = merge(tiles, size: board.size)
            }
        case .right:
            for row in 0..<board.size {
                let tiles = board.cells[row].reversed()
                newBoard.cells[row] = merge(Array(tiles), size: board.size).reversed()
            }
        }

        return newBoard
    }

    private static func merge(_ tiles: [Int?], size: Int) -> [Int?] {
        var queue = tiles.compactMap { $0 }
        var merged: [Int?] = []

        while !queue.isEmpty {
            let current = queue.removeFirst()

            if let next = queue.first, next == current {
                merged.append(current * 2)
                queue.removeFirst()
            } else {
                merged.append(current)
            }
        }
        while merged.count < size {
            merged.append(nil)
        }
        return merged
    }
}
