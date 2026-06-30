import Foundation

/// Configuration for ad placement frequency and behavior.
/// Adjust these values to control how often ads appear in the news feed.
enum AdConfiguration {

    /// Number of news stories between each native ad in the feed.
    /// For example, a value of 5 means an ad appears after every 5th story.
    static let storiesPerAd: Int = 3

    /// Minimum number of stories required before showing the first ad.
    /// Prevents ads from appearing in very short feeds.
    static let minimumStoriesBeforeFirstAd: Int = 3

    /// Maximum number of ads to show in a single feed session.
    /// Set to `nil` for unlimited ads.
    static let maxAdsPerFeed: Int? = 4

    /// Whether ads are enabled globally. Set to `false` to disable all ads
    /// (useful for premium/ad-free tiers or during development).
    static var adsEnabled: Bool = true

    // MARK: - Helpers

    /// Returns the indices where ads should be inserted in a list of the given count.
    static func adInsertionIndices(forStoryCount count: Int) -> [Int] {
        guard adsEnabled, count >= minimumStoriesBeforeFirstAd else { return [] }

        var indices: [Int] = []
        var position = storiesPerAd
        var adCount = 0

        while position < count {
            if let max = maxAdsPerFeed, adCount >= max { break }
            indices.append(position)
            position += storiesPerAd + 1 // +1 accounts for the ad slot itself
            adCount += 1
        }

        return indices
    }
}
