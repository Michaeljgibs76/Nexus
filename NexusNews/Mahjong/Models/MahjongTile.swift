import Foundation

enum TileSuit: String, CaseIterable {
    case man, pin, sou
    case wind, dragon
    case flower, season
}

enum TileRank: Equatable {
    case number(Int)
    case east, south, west, north
    case red, green, white
    case flower(Int)
    case season(Int)
}

struct MahjongTile: Identifiable, Equatable {
    let id: UUID
    let suit: TileSuit
    let rank: TileRank
    let col: Double
    let row: Double
    let layer: Int

    var isSelected: Bool = false
    var isRemoved: Bool = false

    var symbol: String {
        switch (suit, rank) {
        case (.man, .number(let n)): return "\(n)m"
        case (.pin, .number(let n)): return "\(n)p"
        case (.sou, .number(let n)): return "\(n)s"
        case (.wind, .east):  return "東"
        case (.wind, .south): return "南"
        case (.wind, .west):  return "西"
        case (.wind, .north): return "北"
        case (.dragon, .red):   return "中"
        case (.dragon, .green): return "發"
        case (.dragon, .white): return "白"
        case (.flower, .flower(let n)): return ["🌸","🌺","🌼","🌻"][n - 1]
        case (.season, .season(let n)): return ["春","夏","秋","冬"][n - 1]
        default: return "?"
        }
    }

    var displayColor: String {
        switch suit {
        case .man:    return "red"
        case .pin:    return "blue"
        case .sou:    return "green"
        case .wind:   return "purple"
        case .dragon: return "orange"
        case .flower: return "pink"
        case .season: return "teal"
        }
    }

    func matches(_ other: MahjongTile) -> Bool {
        guard suit == other.suit else { return false }
        switch suit {
        case .flower:  return true
        case .season:  return true
        default:       return rank == other.rank
        }
    }

    static func == (lhs: MahjongTile, rhs: MahjongTile) -> Bool {
        lhs.id == rhs.id
    }
}
