// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .library(
            name: "Core",
            targets: ["Core"]),
        .library(
            name: "CoreLogging",
            targets: ["CoreLogging"]),
        .library(
            name: "CoreTracking",
            targets: ["CoreTracking"]),
        .library(
            name: "CoreUI",
            targets: ["CoreUI"])
    ],
    targets: [
        .target(
            name: "Core",
            swiftSettings: swiftSettings),
        .target(
            name: "CoreLogging",
            dependencies: [
                "Core"
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "CoreTracking",
            dependencies: [
                "Core"
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "CoreUI",
            dependencies: [
                "Core",
                "CoreTracking"
            ],
            swiftSettings: swiftSettings),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        )
    ]
)
