import SwiftUI

struct ContentView: View {

    @EnvironmentObject var viewModel: NewsViewModel
    @State private var selectedTab: PoliticalViewpoint = .center

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(PoliticalViewpoint.allCases) { viewpoint in
                NewsListView(viewpoint: viewpoint)
                    .tabItem {
                        Label(viewpoint.rawValue, systemImage: viewpoint.tabIcon)
                    }
                    .tag(viewpoint)
            }
        }
        .tint(selectedTab.color)
        .safeAreaInset(edge: .top, spacing: 0) {
            if !viewModel.isLoading && !viewModel.storiesByViewpoint.isEmpty {
                overallBiasStrip
            }
        }
    }

    private var overallBiasStrip: some View {
        let score = viewModel.overallAverageBias
        let color = biasColor(score)
        return HStack(spacing: 8) {
            Image(systemName: "chart.bar.fill")
                .font(.caption)
                .foregroundColor(color)
            Text("Overall Bias Across All Sources")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text("\(Int(score * 100))% · \(biasLabel(score))")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 7)
        .background(.bar)
        .overlay(alignment: .bottom) { Divider() }
    }

    private func biasColor(_ score: Double) -> Color {
        switch score {
        case 0..<0.25:    return .green
        case 0.25..<0.50: return Color(red: 0.80, green: 0.70, blue: 0.00)
        case 0.50..<0.75: return .orange
        default:           return .red
        }
    }

    private func biasLabel(_ score: Double) -> String {
        switch score {
        case 0.0..<0.20: return "Minimal Lean"
        case 0.20..<0.40: return "Slight Lean"
        case 0.40..<0.60: return "Moderate Lean"
        case 0.60..<0.80: return "Strong Lean"
        default:          return "Extreme Lean"
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NewsViewModel())
}
