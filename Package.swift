// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AudiobookshelfAPI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "AudiobookshelfAPI",
            targets: [
                "AudiobookshelfAPI",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/JamesRagnar/RagnarNetworking",
            revision: "3e25b8305cbc80356b0398f8861cb0c7ec2fa562"
        ),
    ],
    targets: [
        .target(
            name: "AudiobookshelfAPI",
            dependencies: [
                .product(
                    name: "RagnarNetworking",
                    package: "RagnarNetworking"
                ),
            ]
        ),
        .testTarget(
            name: "AudiobookshelfAPITests",
            dependencies: [
                "AudiobookshelfAPI",
            ]
        ),
    ]
)
