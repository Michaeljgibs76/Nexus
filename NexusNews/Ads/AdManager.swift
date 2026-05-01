import Foundation
import GoogleMobileAds

/// Central configuration and initialization for Google AdMob.
/// Replace the test ad unit IDs with your production IDs before releasing.
enum AdManager {

    // MARK: - Ad Unit IDs

    /// Test native ad unit ID provided by Google for development.
    /// Replace with your production ad unit ID before App Store submission.
    static let nativeAdUnitID = "ca-app-pub-3940256099942544/3986624511"

    // MARK: - Initialization

    /// Call this once at app launch to initialize the Google Mobile Ads SDK.
    static func configure() {
        MobileAds.shared.start()
    }
}
