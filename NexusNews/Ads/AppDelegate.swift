import UIKit
import GoogleMobileAds

/// Optional AppDelegate for apps that need UIKit lifecycle hooks.
/// The Google Mobile Ads SDK is initialized in `NexusNewsApp.init()` via `AdManager.configure()`,
/// but this delegate can be used if you switch to a UIKit app lifecycle in the future.
class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // SDK initialization is handled by AdManager.configure() in NexusNewsApp.
        return true
    }
}
