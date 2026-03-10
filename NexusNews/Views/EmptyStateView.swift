import SwiftUI

struct EmptyStateView: View {
    let viewpoint: PoliticalViewpoint
    let searchText: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: searchText.isEmpty ? viewpoint.tabIcon : "magnifyingglass")
                .font(.system(size: 50))
                .foregroundStyle(viewpoint.gradient)

            Text(searchText.isEmpty ? "No Stories Yet" : "No Results")
                .font(.headline)

            Text(
                searchText.isEmpty
                    ? "Pull to refresh and load the latest \(viewpoint.rawValue.lowercased()) news."
                    : "No stories match "\(searchText)". Try a different term."
            )
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 36)
        }
        .padding(.top, 60)
    }
}
