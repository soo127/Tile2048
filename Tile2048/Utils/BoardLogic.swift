//
//  BoardLogic.swift
//  Tile2048
//
//  Created by 이상수 on 10/10/25.
//

import Foundation

enum BoardLogic {
    static func emptyPositions(_ board: Board) -> [(row: Int, col: Int)] {
        var positions: [(Int, Int)] = []
        for row in 0..<board.size {
            for col in 0..<board.size where board.cells[row][col] == nil {
                positions.append((row, col))
            }
        }
        return positions
    }

    static func move(_ board: Board, direction: Direction) -> MoveResult {
        var newBoard = board
        var gainedScore = 0

        switch direction {
        case .up:
            for col in 0..<board.size {
                let tiles = (0..<board.size).map { board.cells[$0][col] }
                let merged = merge(tiles, size: board.size)
                gainedScore += merged.scoreDelta
                for row in 0..<board.size {
                    newBoard.cells[row][col] = merged.line[row]
                }
            }
        case .down:
            for col in 0..<board.size {
                let tiles = (0..<board.size).reversed().map { board.cells[$0][col] }
                let merged = merge(tiles, size: board.size)
                gainedScore += merged.scoreDelta
                let line = Array(merged.line.reversed())
                for row in 0..<board.size {
                    newBoard.cells[row][col] = line[row]
                }
            }
        case .left:
            for row in 0..<board.size {
                let tiles = board.cells[row]
                let merged = merge(tiles, size: board.size)
                gainedScore += merged.scoreDelta
                newBoard.cells[row] = merged.line
            }
        case .right:
            for row in 0..<board.size {
                let tiles = Array(board.cells[row].reversed())
                let merged = merge(tiles, size: board.size)
                gainedScore += merged.scoreDelta
                newBoard.cells[row] = merged.line.reversed()
            }
        }

        return MoveResult(board: newBoard, scoreDelta: gainedScore)
    }

    private static func merge(_ tiles: [Int?], size: Int) -> LineMergeResult {
        var queue = tiles.compactMap { $0 }
        var merged: [Int?] = []
        var gained = 0

        while !queue.isEmpty {
            let current = queue.removeFirst()
            if let next = queue.first, next == current {
                let newValue = current * 2
                merged.append(newValue)
                gained += newValue
                queue.removeFirst()
            } else {
                merged.append(current)
            }
        }
        while merged.count < size {
            merged.append(nil)
        }
        return LineMergeResult(line: merged, scoreDelta: gained)
    }

    static func determineDirection(_ translation: CGSize) -> Direction {
        let horizontal = abs(translation.width)
        let vertical = abs(translation.height)

        if horizontal > vertical {
            return translation.width > 0 ? .right : .left
        } else {
            return translation.height > 0 ? .down : .up
        }
    }
}

extension BoardLogic {
    struct MoveResult {
        let board: Board
        let scoreDelta: Int
    }

    private struct LineMergeResult {
        let line: [Int?]
        let scoreDelta: Int
    }
}
