// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NavTalkSPM",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "NavTalkSPM",
            targets: ["NavTalkSPM"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scalessec/Toast-Swift.git", from: "5.0.0"),
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.5"),
        .package(url: "https://github.com/stasel/WebRTC.git", from: "140.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.20.0")
    ],
    targets: [
        .target(
            name: "NavTalkSPM",
            dependencies: [
                .product(name: "Toast", package: "Toast-Swift"),
                "Starscream",
                "WebRTC",
                "SDWebImage"
            ],
            path: "Sources",
            resources: [
                .process("Assets")
            ]
        ),
    ]
)
