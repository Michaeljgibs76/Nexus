import Foundation
import SwiftUI

@MainActor
final class MahjongViewModel: ObservableObject {
    @Published var tiles: [MahjongTile] = []
    @Published var score: Int = 0
    @Published var moves: Int = 0
    @Published var isGameWon: Bool = false
    @Published var isGameOver: Bool = false
    @Published var hintPair: (UUID, UUID)? = nil
    @Published var elapsedSeconds: Int = 0

    private var undoStack: [(removed1: MahjongTile, removed2: MahjongTile)] = []
    private var timer: Timer?
    private var selectedID: UUID? = nil

    var activeTiles: [MahjongTile] { tiles.filter { !$0.isRemoved } }

    func newGame() {
        tiles = MahjongLayout.makeTiles()
        score = 0
        moves = 0
        elapsedSeconds = 0
        isGameWon = false
        isGameOver = false
        hintPair = nil
        selectedID = nil
        undoStack = []
        clearSelections()
        startTimer()
    }

    func tap(tile: MahjongTile) {
        guard isFree(tile) else { return }
        hintPair = nil

        if let sel = selectedID, sel == tile.id {
            deselect(id: sel)
            selectedID = nil
            return
        }

        if let sel = selectedID, let selIdx = tiles.firstIndex(where: { $0.id == sel }) {
            let selTile = tiles[selIdx]
            if selTile.matches(tile) {
                removePair(selTile, tile)
            } else {
                deselect(id: sel)
                select(id: tile.id)
                selectedID = tile.id
            }
        } else {
            select(id: tile.id)
            selectedID = tile.id
        }
    }

    func hint() {
        guard let pair = findHintPair() else { return }
        hintPair = (pair.0.id, pair.1.id)
    }

    func undo() {
        guard let last = undoStack.popLast() else { return }
        restoreTile(last.removed1)
        restoreTile(last.removed2)
        if moves > 0 { moves -= 1 }
        if score >= 10 { score -= 10 }
        selectedID = nil
        clearSelections()
        checkGameOver()
    }

    func isFree(_ tile: MahjongTile) -> Bool {
        guard !tile.isRemoved else { return false }
        if isCovered(tile) { return false }
        return hasOpenSide(tile)
    }

    // MARK: - Private

    private func removePair(_ a: MahjongTile, _ b: MahjongTile) {
        undoStack.append((removed1: a, removed2: b))
        setRemoved(id: a.id, removed: true)
        setRemoved(id: b.id, removed: true)
        selectedID = nil
        moves += 1
        score += 10
        checkWin()
        checkGameOver()
    }

    private func isCovered(_ tile: MahjongTile) -> Bool {
        activeTiles.contains { other in
            other.id != tile.id &&
            other.layer == tile.layer + 1 &&
            abs(other.col - tile.col) < 2 &&
            abs(other.row - tile.row) < 2
        }
    }

    private func hasOpenSide(_ tile: MahjongTile) -> Bool {
        let blockedLeft = activeTiles.contains { other in
            other.id != tile.id &&
            other.layer == tile.layer &&
            abs(other.row - tile.row) < 2 &&
            other.col == tile.col - 2
        }
        let blockedRight = activeTiles.contains { other in
            other.id != tile.id &&
            other.layer == tile.layer &&
            abs(other.row - tile.row) < 2 &&
            other.col == tile.col + 2
        }
        return !blockedLeft || !blockedRight
    }

    private func findHintPair() -> (MahjongTile, MahjongTile)? {
        let free = activeTiles.filter { isFree($0) }
        for i in 0..<free.count {
            for j in (i + 1)..<free.count {
                if free[i].matches(free[j]) {
                    return (free[i], free[j])
                }
            }
        }
        return nil
    }

    private func checkWin() {
        if activeTiles.isEmpty {
            isGameWon = true
            score += max(0, 300 - elapsedSeconds)
            timer?.invalidate()
        }
    }

    private func checkGameOver() {
        guard !isGameWon else { return }
        if activeTiles.isEmpty { return }
        isGameOver = findHintPair() == nil
        if isGameOver { timer?.invalidate() }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.elapsedSeconds += 1 }
        }
    }

    private func select(id: UUID) {
        if let idx = tiles.firstIndex(where: { $0.id == id }) {
            tiles[idx].isSelected = true
        }
    }

    private func deselect(id: UUID) {
        if let idx = tiles.firstIndex(where: { $0.id == id }) {
            tiles[idx].isSelected = false
        }
    }

    private func clearSelections() {
        for i in tiles.indices { tiles[i].isSelected = false }
    }

    private func setRemoved(id: UUID, removed: Bool) {
        if let idx = tiles.firstIndex(where: { $0.id == id }) {
            tiles[idx].isRemoved = removed
            tiles[idx].isSelected = false
        }
    }

    private func restoreTile(_ tile: MahjongTile) {
        if let idx = tiles.firstIndex(where: { $0.id == tile.id }) {
            tiles[idx].isRemoved = false
        }
    }

    var timeString: String {
        let m = elapsedSeconds / 60
        let s = elapsedSeconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
