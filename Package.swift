// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
        .library(
            name: "CoreTracking",
            targets: ["CoreTracking"]),
        .library(
            name: "CoreUI",
            targets: ["CoreUI"])
    ],
    targets: [
        .target(
            name: "Core"),
        .target(
            name: "CoreTracking",
            dependencies: [
                "Core"
            ]),
        .target(
            name: "CoreUI",
            dependencies: [
                "Core",
                "CoreTracking"
            ]),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        )
    ]
)
