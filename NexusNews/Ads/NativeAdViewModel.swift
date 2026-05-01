import Foundation
import GoogleMobileAds
import SwiftUI

/// ViewModel responsible for loading and managing a single Google AdMob native ad.
/// Publishes the loaded `NativeAd` for consumption by SwiftUI views.
@MainActor
final class NativeAdViewModel: NSObject, ObservableObject {

    // MARK: - Published State

    @Published var nativeAd: NativeAd?
    @Published var isAdLoaded = false

    // MARK: - Private

    private var adLoader: AdLoader?

    // MARK: - Public Methods

    /// Requests a new native ad from AdMob.
    func loadAd() {
        let adLoader = AdLoader(
            adUnitID: AdManager.nativeAdUnitID,
            rootViewController: nil,
            adTypes: [.native],
            options: nil
        )
        adLoader.delegate = self
        self.adLoader = adLoader
        adLoader.load(Request())
    }
}

// MARK: - AdLoaderDelegate

extension NativeAdViewModel: AdLoaderDelegate {

    nonisolated func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        Task { @MainActor in
            self.nativeAd = nativeAd
            self.isAdLoaded = true
            nativeAd.delegate = self
        }
    }

    nonisolated func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        Task { @MainActor in
            self.isAdLoaded = false
            print("[NexusNews Ads] Failed to load native ad: \(error.localizedDescription)")
        }
    }
}

// MARK: - NativeAdDelegate

extension NativeAdViewModel: NativeAdDelegate {

    nonisolated func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        print("[NexusNews Ads] Native ad recorded an impression.")
    }

    nonisolated func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        print("[NexusNews Ads] Native ad recorded a click.")
    }

    nonisolated func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
        print("[NexusNews Ads] Native ad will present screen.")
    }

    nonisolated func nativeAdWillDismissScreen(_ nativeAd: NativeAd) {
        print("[NexusNews Ads] Native ad will dismiss screen.")
    }

    nonisolated func nativeAdDidDismissScreen(_ nativeAd: NativeAd) {
        print("[NexusNews Ads] Native ad did dismiss screen.")
    }
}
