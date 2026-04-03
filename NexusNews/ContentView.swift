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
    }
}

#Preview {
    ContentView()
        .environmentObject(NewsViewModel())
}
