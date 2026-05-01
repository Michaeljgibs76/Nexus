import SwiftUI

struct MahjongBoardView: View {
    @ObservedObject var viewModel: MahjongViewModel

    private let tileW: CGFloat = 44
    private let tileH: CGFloat = 56
    private let colUnit: CGFloat = 22
    private let rowUnit: CGFloat = 28
    private let layerOffset: CGFloat = 3

    var body: some View {
        GeometryReader { geo in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                ZStack(alignment: .topLeading) {
                    Color.clear.frame(width: boardWidth, height: boardHeight)

                    ForEach(viewModel.tiles) { tile in
                        if !tile.isRemoved {
                            let x = xPos(tile)
                            let y = yPos(tile)
                            let free = viewModel.isFree(tile)
                            let hinted = isHinted(tile)

                            MahjongTileView(
                                tile: tile,
                                isHinted: hinted,
                                isFree: free,
                                tileWidth: tileW,
                                tileHeight: tileH,
                                onTap: { viewModel.tap(tile: tile) }
                            )
                            .position(x: x, y: y)
                            .zIndex(Double(tile.layer) * 1000 + (tile.isSelected ? 500 : 0))
                        }
                    }
                }
                .frame(width: boardWidth, height: boardHeight)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private var boardWidth: CGFloat  { colUnit * 30 + tileW + layerOffset * 5 + 40 }
    private var boardHeight: CGFloat { rowUnit * 13 + tileH + layerOffset * 5 + 40 }

    private func xPos(_ tile: MahjongTile) -> CGFloat {
        let base = tile.col * colUnit + tileW / 2 + 20
        return base + CGFloat(tile.layer) * layerOffset
    }

    private func yPos(_ tile: MahjongTile) -> CGFloat {
        let base = tile.row * rowUnit + tileH / 2 + 20
        return base - CGFloat(tile.layer) * layerOffset
    }

    private func isHinted(_ tile: MahjongTile) -> Bool {
        guard let pair = viewModel.hintPair else { return false }
        return tile.id == pair.0 || tile.id == pair.1
    }
}
