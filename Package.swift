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
            targets: ["CoreTracking"])
    ],
    targets: [
        .target(
            name: "Core"),
        .target(
            name: "CoreTracking",
            dependencies: [
                "Core"
            ]),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        )
    ]
)
