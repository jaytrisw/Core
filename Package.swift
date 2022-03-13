// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]),
        .library(
            name: "Log",
            targets: ["Log"]),
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]),
        .library(
            name: "CoreTest",
            targets: ["CoreTest"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: []),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core", "CoreTest"]),
        .target(
            name: "CoreUI",
            dependencies: ["Core"]),
        .testTarget(
            name: "CoreUITests",
            dependencies: ["Core", "CoreUI", "CoreTest"]),
        .target(
            name: "Log",
            dependencies: ["Core"]),
        .target(
            name: "NetworkService",
            dependencies: ["Core", "Log"]),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: [
                "NetworkService",
                "CoreTest"
            ]),
        .target(
            name: "CoreTest",
            dependencies: ["Core", "NetworkService"])
    ]
)
