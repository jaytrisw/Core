// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
        .library(
            name: "Tracking",
            targets: ["Tracking"])
    ],
    targets: [
        .target(
            name: "Core"),
        .target(
            name: "Tracking",
            dependencies: [
                "Core"
            ]),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        )
    ]
)
