import Foundation

struct TilePosition {
    let col: Double
    let row: Double
    let layer: Int
}

enum MahjongLayout {
    static let turtle: [TilePosition] = buildTurtleLayout()

    private static func buildTurtleLayout() -> [TilePosition] {
        var positions: [TilePosition] = []

        // Layer 0: main 12x8 field (inner positions vary)
        let layer0Rows: [(row: Double, cols: [Double])] = [
            (0, [2,4,6,8,10,12,14,16,18,20,22,24]),
            (2, [2,4,6,8,10,12,14,16,18,20,22,24]),
            (3, [0,2,4,6,8,10,12,14,16,18,20,22,24,26]),
            (4, [2,4,6,8,10,12,14,16,18,20,22,24]),
            (5, [2,4,6,8,10,12,14,16,18,20,22,24]),
            (6, [2,4,6,8,10,12,14,16,18,20,22,24]),
            (7, [0,2,4,6,8,10,12,14,16,18,20,22,24,26]),
            (8, [2,4,6,8,10,12,14,16,18,20,22,24]),
            (9, [2,4,6,8,10,12,14,16,18,20,22,24]),
            (11,[2,4,6,8,10,12,14,16,18,20,22,24]),
        ]
        for rowEntry in layer0Rows {
            for col in rowEntry.cols {
                positions.append(TilePosition(col: col, row: rowEntry.row, layer: 0))
            }
        }

        // Layer 1: reduced grid
        let layer1Rows: [(row: Double, cols: [Double])] = [
            (2, [4,6,8,10,12,14,16,18,20,22]),
            (4, [4,6,8,10,12,14,16,18,20,22]),
            (5, [4,6,8,10,12,14,16,18,20,22]),
            (7, [4,6,8,10,12,14,16,18,20,22]),
            (9, [4,6,8,10,12,14,16,18,20,22]),
        ]
        for rowEntry in layer1Rows {
            for col in rowEntry.cols {
                positions.append(TilePosition(col: col, row: rowEntry.row, layer: 1))
            }
        }

        // Layer 2: smaller center
        let layer2Rows: [(row: Double, cols: [Double])] = [
            (4, [8,10,12,14,16,18]),
            (5, [8,10,12,14,16,18]),
            (7, [8,10,12,14,16,18]),
        ]
        for rowEntry in layer2Rows {
            for col in rowEntry.cols {
                positions.append(TilePosition(col: col, row: rowEntry.row, layer: 2))
            }
        }

        // Layer 3: top center
        let layer3Rows: [(row: Double, cols: [Double])] = [
            (5, [10,12,14,16]),
            (6, [10,12,14,16]),
        ]
        for rowEntry in layer3Rows {
            for col in rowEntry.cols {
                positions.append(TilePosition(col: col, row: rowEntry.row, layer: 3))
            }
        }

        // Layer 4: single peak
        positions.append(TilePosition(col: 13, row: 5.5, layer: 4))

        return positions
    }

    static func makeTiles() -> [MahjongTile] {
        var specs: [(TileSuit, TileRank)] = []

        for n in 1...9 {
            for _ in 0..<4 { specs.append((.man, .number(n))) }
            for _ in 0..<4 { specs.append((.pin, .number(n))) }
            for _ in 0..<4 { specs.append((.sou, .number(n))) }
        }
        let winds: [TileRank] = [.east, .south, .west, .north]
        for w in winds { for _ in 0..<4 { specs.append((.wind, w)) } }
        let dragons: [TileRank] = [.red, .green, .white]
        for d in dragons { for _ in 0..<4 { specs.append((.dragon, d)) } }
        for n in 1...4 { specs.append((.flower, .flower(n))) }
        for n in 1...4 { specs.append((.season, .season(n))) }

        var shuffled = specs.shuffled()
        let layout = turtle

        // Trim or pad to fit layout count
        let count = min(shuffled.count, layout.count)
        shuffled = Array(shuffled.prefix(count))
        let usedLayout = Array(layout.prefix(count))

        return zip(shuffled, usedLayout).map { spec, pos in
            MahjongTile(
                id: UUID(),
                suit: spec.0,
                rank: spec.1,
                col: pos.col,
                row: pos.row,
                layer: pos.layer
            )
        }
    }
}
