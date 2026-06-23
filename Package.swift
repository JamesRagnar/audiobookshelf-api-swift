// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AudiobookshelfAPI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
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
            name: "RagnarNetworking", path: "../RagnarNetworking"
        )
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
