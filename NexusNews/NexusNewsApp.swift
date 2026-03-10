import SwiftUI

@main
struct NexusNewsApp: App {

    @StateObject private var newsViewModel = NewsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(newsViewModel)
        }
    }
}
