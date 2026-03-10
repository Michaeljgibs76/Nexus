import Foundation
import Combine
import SwiftUI

@MainActor
final class NewsViewModel: ObservableObject {

    // MARK: - Published state

    @Published var storiesByViewpoint: [PoliticalViewpoint: [NewsStory]] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var sortOption: SortOption = .newest

    // MARK: - Types

    enum SortOption: String, CaseIterable, Identifiable {
        case newest      = "Newest First"
        case highestBias = "Most Biased"
        case lowestBias  = "Least Biased"
        var id: String { rawValue }
    }

    // MARK: - Private

    private let newsService = NewsService()

    // MARK: - Init

    init() {
        Task { await loadStories() }
    }

    // MARK: - Public API

    func stories(for viewpoint: PoliticalViewpoint) -> [NewsStory] {
        storiesByViewpoint[viewpoint] ?? []
    }

    func refresh() {
        Task { await loadStories() }
    }

    func setSortOption(_ option: SortOption) {
        sortOption = option
        var grouped: [PoliticalViewpoint: [NewsStory]] = [:]
        for vp in PoliticalViewpoint.allCases {
            grouped[vp] = sort(storiesByViewpoint[vp] ?? [])
        }
        storiesByViewpoint = grouped
    }

    var overallAverageBias: Double {
        let all = storiesByViewpoint.values.flatMap { $0 }
        guard !all.isEmpty else { return 0 }
        return all.reduce(0) { $0 + $1.biasScore } / Double(all.count)
    }

    // MARK: - Private helpers

    private func loadStories() async {
        isLoading = true
        errorMessage = nil
        do {
            let all = try await newsService.fetchStories()
            var grouped: [PoliticalViewpoint: [NewsStory]] = [:]
            for vp in PoliticalViewpoint.allCases {
                grouped[vp] = sort(all.filter { $0.viewpoint == vp })
            }
            storiesByViewpoint = grouped
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func sort(_ stories: [NewsStory]) -> [NewsStory] {
        switch sortOption {
        case .newest:      return stories.sorted { $0.publishedAt > $1.publishedAt }
        case .highestBias: return stories.sorted { $0.biasScore   > $1.biasScore   }
        case .lowestBias:  return stories.sorted { $0.biasScore   < $1.biasScore   }
        }
    }
}
