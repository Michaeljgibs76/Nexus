import SwiftUI

struct MahjongTileView: View {
    let tile: MahjongTile
    let isHinted: Bool
    let isFree: Bool
    let tileWidth: CGFloat
    let tileHeight: CGFloat
    let onTap: () -> Void

    private var tileColor: Color {
        if tile.isSelected { return Color.yellow.opacity(0.9) }
        if isHinted { return Color.mint.opacity(0.85) }
        if !isFree { return Color(white: 0.82) }
        return Color(white: 0.97)
    }

    private var shadowColor: Color {
        isFree ? Color.black.opacity(0.25) : Color.clear
    }

    private var textColor: Color {
        guard !tile.isSelected && !isHinted else { return .black }
        switch tile.displayColor {
        case "red":    return .red
        case "blue":   return Color(red: 0.1, green: 0.2, blue: 0.8)
        case "green":  return Color(red: 0.1, green: 0.5, blue: 0.2)
        case "purple": return .purple
        case "orange": return .orange
        case "pink":   return .pink
        case "teal":   return .teal
        default:       return .black
        }
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(tileColor)
                    .shadow(color: shadowColor, radius: 2, x: 1, y: 2)

                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(
                        tile.isSelected ? Color.orange : Color.gray.opacity(0.5),
                        lineWidth: tile.isSelected ? 2 : 0.5
                    )

                Text(tile.symbol)
                    .font(.system(size: tileWidth * 0.38, weight: .semibold))
                    .foregroundColor(textColor)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            .frame(width: tileWidth, height: tileHeight)
        }
        .buttonStyle(.plain)
        .disabled(!isFree)
        .opacity(tile.isRemoved ? 0 : 1)
        .animation(.easeInOut(duration: 0.15), value: tile.isRemoved)
    }
}
