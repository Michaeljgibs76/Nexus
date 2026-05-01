// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NexusNews",
    platforms: [.iOS(.v16)],
    dependencies: [
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            from: "11.14.0"
        )
    ],
    targets: []
)
