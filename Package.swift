// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ValidateKit",
    products: [
        .library(
            name: "ValidateKit",
            targets: ["ValidateKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ValidateKit",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "ValidateKitTests",
            dependencies: ["ValidateKit"],
            path: "Tests"
        ),
    ]
)
