import SwiftUI
import GoogleMobileAds

@main
struct NexusNewsApp: App {

    @StateObject private var newsViewModel = NewsViewModel()

    init() {
        // Initialize Google Mobile Ads SDK as early as possible.
        AdManager.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(newsViewModel)
        }
    }
}
