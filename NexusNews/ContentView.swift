import SwiftUI

enum RootTab: Hashable {
    case news(PoliticalViewpoint)
    case mahjong
}

struct ContentView: View {

    @EnvironmentObject var viewModel: NewsViewModel
    @State private var selectedTab: RootTab = .news(.center)

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(PoliticalViewpoint.allCases) { viewpoint in
                NewsListView(viewpoint: viewpoint)
                    .tabItem {
                        Label(viewpoint.rawValue, systemImage: viewpoint.tabIcon)
                    }
                    .tag(RootTab.news(viewpoint))
            }

            MahjongGameView()
                .tabItem {
                    Label("Mahjong", systemImage: "grid.circle.fill")
                }
                .tag(RootTab.mahjong)
        }
        .tint(tintForTab)
    }

    private var tintForTab: Color {
        if case .news(let vp) = selectedTab { return vp.color }
        return Color(red: 0.13, green: 0.37, blue: 0.19)
    }
}

#Preview {
    ContentView()
        .environmentObject(NewsViewModel())
}
