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
        .library(
            name: "Core",
            targets: ["Core"]),
        .library(
            name: "CoreLogging",
            targets: ["CoreLogging"]),
        .library(
            name: "CoreTesting",
            targets: ["CoreTesting"]),
        .library(
            name: "CoreTracking",
            targets: ["CoreTracking", "CoreTrackingMocks"]),
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
            name: "CoreTesting",
            dependencies: [
                "Core"
            ],
            swiftSettings: swiftSettings,
            linkerSettings: [
                .linkedFramework("XCTest")
            ]),
        .target(
            name: "CoreTracking",
            dependencies: [
                "Core"
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "CoreTrackingMocks",
            dependencies: [
                "Core",
                "CoreTracking"
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
            dependencies: [
                "Core",
                "CoreTesting"
            ]
        ),
        .testTarget(
            name: "CoreTrackingTests",
            dependencies: [
                "Core",
                "CoreTesting",
                "CoreTracking",
                "CoreTrackingMocks"
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
