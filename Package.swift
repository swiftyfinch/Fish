// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "fish",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Fish",
            targets: ["Fish"]
        )
    ],
    targets: [
        .target(
            name: "Fish",
            path: "Sources"
        ),
        .testTarget(
            name: "FishTests",
            dependencies: ["Fish"],
            path: "Tests"
        )
    ]
)
