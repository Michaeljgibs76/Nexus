import SwiftUI

struct MahjongGameView: View {
    @StateObject private var viewModel = MahjongViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                statsBar
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))

                Divider()

                MahjongBoardView(viewModel: viewModel)
                    .background(Color(red: 0.13, green: 0.37, blue: 0.19).opacity(0.15))

                Divider()

                controlBar
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(.systemBackground))
            }
            .navigationTitle("Mahjong Solitaire")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if viewModel.isGameWon { winOverlay }
                else if viewModel.isGameOver { loseOverlay }
            }
        }
        .onAppear { viewModel.newGame() }
    }

    private var statsBar: some View {
        HStack {
            Label(viewModel.timeString, systemImage: "clock")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
            Spacer()
            Label("\(viewModel.score)", systemImage: "star.fill")
                .font(.subheadline.bold())
                .foregroundStyle(.orange)
            Spacer()
            Label("\(viewModel.activeTiles.count) left", systemImage: "square.grid.3x3.fill")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var controlBar: some View {
        HStack(spacing: 20) {
            ControlButton(icon: "arrow.clockwise", label: "New Game") {
                viewModel.newGame()
            }
            ControlButton(icon: "lightbulb", label: "Hint") {
                viewModel.hint()
            }
            ControlButton(icon: "arrow.uturn.backward", label: "Undo") {
                viewModel.undo()
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var winOverlay: some View {
        overlayCard(
            icon: "trophy.fill",
            iconColor: .yellow,
            title: "You Win!",
            message: "Score: \(viewModel.score)  •  Time: \(viewModel.timeString)",
            buttonLabel: "Play Again"
        )
    }

    private var loseOverlay: some View {
        overlayCard(
            icon: "xmark.octagon.fill",
            iconColor: .red,
            title: "No Moves Left",
            message: "No more matching pairs available.",
            buttonLabel: "Try Again"
        )
    }

    private func overlayCard(
        icon: String,
        iconColor: Color,
        title: String,
        message: String,
        buttonLabel: String
    ) -> some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 52))
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.largeTitle.bold())
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button(buttonLabel) { viewModel.newGame() }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.13, green: 0.37, blue: 0.19))
                    .controlSize(.large)
            }
            .padding(32)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .padding(40)
        }
    }
}

private struct ControlButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                Text(label)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .buttonStyle(.bordered)
        .tint(Color(red: 0.13, green: 0.37, blue: 0.19))
    }
}

#Preview {
    MahjongGameView()
}
