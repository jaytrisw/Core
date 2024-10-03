// swift-tools-version: 6.0

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("StrictConcurrency")
]

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .library(name: "CoreLogging", targets: ["CoreLogging"]),
        .library(name: "CoreNetworking", targets: ["CoreNetworking"]),
        .library(name: "CoreTesting", targets: ["CoreTesting"]),
        .library(name: "CoreTracking", targets: ["CoreTracking", "CoreTrackingMocks"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
        .library(name: "FirebaseTracking", targets: ["FirebaseTracking"]),
        .library(name: "MixpanelTracking", targets: ["MixpanelTracking"])
    ],
    dependencies: [
        .package(url: "https://github.com/mixpanel/mixpanel-swift.git", exact: "4.3.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "11.2.0")
    ],
    targets: [
        .target(name: "Core", swiftSettings: swiftSettings),
        .target(name: "CoreLogging", dependencies: ["Core"], swiftSettings: swiftSettings),
        .target(name: "CoreNetworking", dependencies: ["Core", "CoreLogging"], swiftSettings: swiftSettings),
        .target(name: "CoreTesting", dependencies: ["Core"], swiftSettings: swiftSettings),
        .target(name: "CoreTracking", dependencies: ["Core"], swiftSettings: swiftSettings),
        .target(name: "CoreTrackingMocks", dependencies: ["Core", "CoreTracking"], swiftSettings: swiftSettings),
        .target(name: "CoreUI", dependencies: ["Core", "CoreTracking"], swiftSettings: swiftSettings),
        .target(
            name: "FirebaseTracking",
            dependencies: ["Core", "CoreTracking", .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")],
            path: "Implementations/CoreTracking/FirebaseTracking",
            swiftSettings: swiftSettings),
        .target(
            name: "MixpanelTracking",
            dependencies: ["Core", "CoreTracking", .product(name: "Mixpanel", package: "mixpanel-swift")],
            path: "Implementations/CoreTracking/MixpanelTracking",
            swiftSettings: swiftSettings),
        .testTarget(name: "CoreTests", dependencies: ["Core", "CoreTesting"]),
        .testTarget(name: "CoreTrackingTests", dependencies: ["Core", "CoreTesting", "CoreTracking", "CoreTrackingMocks"])
    ],
    swiftLanguageModes: [.v6]
)
