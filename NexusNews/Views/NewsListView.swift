import SwiftUI

struct NewsListView: View {

    let viewpoint: PoliticalViewpoint
    @EnvironmentObject var viewModel: NewsViewModel
    @State private var searchText = ""

    // MARK: - Computed

    var displayedStories: [NewsStory] {
        let stories = viewModel.stories(for: viewpoint)
        guard !searchText.isEmpty else { return stories }
        return stories.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.source.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                Group {
                    if viewModel.isLoading {
                        loadingView
                    } else if let err = viewModel.errorMessage {
                        ErrorView(error: err) { viewModel.refresh() }
                    } else {
                        storiesList
                    }
                }
            }
            .navigationTitle(viewpoint.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText,
                        prompt: "Search \(viewpoint.rawValue.lowercased()) news…")
            .toolbar { sortMenu }
        }
        .tint(viewpoint.color)
    }

    // MARK: - Sub-views

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.4)
                .tint(viewpoint.color)
            Text("Loading stories…")
                .foregroundColor(.secondary)
        }
    }

    private var storiesList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                headerCard

                if displayedStories.isEmpty {
                    EmptyStateView(viewpoint: viewpoint, searchText: searchText)
                } else {
                    ForEach(displayedStories) { story in
                        NavigationLink(destination: NewsDetailView(story: story)) {
                            NewsStoryCard(story: story)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .refreshable { viewModel.refresh() }
    }

    private var headerCard: some View {
        HStack(spacing: 12) {
            Image(systemName: viewpoint.tabIcon)
                .font(.title2)
                .foregroundStyle(viewpoint.gradient)

            VStack(alignment: .leading, spacing: 2) {
                Text(viewpoint.description)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(displayedStories.count) stories")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Average bias badge
            if !displayedStories.isEmpty {
                let avg = displayedStories.reduce(0) { $0 + $1.biasScore } / Double(displayedStories.count)
                avgBiasBadge(avg)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
        .padding(.top, 8)
    }

    private func avgBiasBadge(_ avg: Double) -> some View {
        let color = biasColor(avg)
        return VStack(spacing: 2) {
            Text("Avg Lean")
                .font(.caption2)
                .foregroundColor(.secondary)
            Text("\(Int(avg * 100))%")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.14))
        .cornerRadius(8)
    }

    private var sortMenu: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                ForEach(NewsViewModel.SortOption.allCases) { opt in
                    Button {
                        viewModel.setSortOption(opt)
                    } label: {
                        HStack {
                            Text(opt.rawValue)
                            if viewModel.sortOption == opt {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down.circle")
            }
        }
    }

    private func biasColor(_ score: Double) -> Color {
        switch score {
        case 0..<0.25: return .green
        case 0.25..<0.50: return Color(red: 0.80, green: 0.70, blue: 0.00)
        case 0.50..<0.75: return .orange
        default:           return .red
        }
    }
}
