// swift-tools-version:5.9

import PackageDescription

let package: Package = Package(name: "Downer", platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
        .tvOS(.v17)
    ], products: [
        .executable(name: "downer-cli", targets: [
            "DownerCLI"
        ]),
        .library(name: "DownerUI", targets: [
            "DownerUI"
        ]),
        .library(name: "Downer", targets: [
            "Downer"
        ])
    ], dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main"),
        .package(url: "https://github.com/apple/swift-markdown", branch: "main")
    ], targets: [
        .executableTarget(name: "DownerCLI", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "DownerUI",
            "Downer"
        ]),
        .target(name: "DownerUI", dependencies: [
           "Downer"
        ], resources: [
            .process("Assets.xcassets")
        ]),
        .testTarget(name: "DownerUITests", dependencies: [
            "DownerUI",
            "Downer"
        ]),
        .target(name: "Downer", dependencies: [
            .product(name: "Markdown", package: "swift-markdown")
        ]),
        .testTarget(name: "DownerTests", dependencies: [
            "Downer"
        ])
    ])
