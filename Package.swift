// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NavTalkSPMCode",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "NavTalkSPMCode",
            targets: ["NavTalkSPMCode"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scalessec/Toast-Swift.git", from: "5.0.0"),
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.5"),
        .package(url: "https://github.com/stasel/WebRTC.git", from: "140.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.20.0")
    ],
    targets: [
        .target(
            name: "NavTalkSPMCode",
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
