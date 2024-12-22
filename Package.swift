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
            name: "AudiobookshelfInterface",
            targets: ["AudiobookshelfInterface"]
        ),
        .library(
            name: "AudiobookshelfModel",
            targets: ["AudiobookshelfModel"]
        ),
        .library(
            name: "AudiobookshelfService",
            targets: ["AudiobookshelfService"]
        ),
        .library(
            name: "AudiobookshelfSocket",
            targets: ["AudiobookshelfSocket"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/socketio/socket.io-client-swift",
            .upToNextMinor(from: "16.1.1")
        )
    ],
    targets: [
        .target(
            name: "AudiobookshelfInterface",
            dependencies: ["AudiobookshelfModel"]
        ),
        .target(
            name: "AudiobookshelfModel",
            dependencies: []
        ),
        .target(
            name: "AudiobookshelfService",
            dependencies: [
                "AudiobookshelfInterface",
                "AudiobookshelfModel",
                "AudiobookshelfSocket",
                .product(
                    name: "SocketIO",
                    package: "socket.io-client-swift"
                )
            ]
        ),
        .target(
            name: "AudiobookshelfSocket",
            dependencies: [
                .product(
                    name: "SocketIO",
                    package: "socket.io-client-swift"
                )
            ]
        ),
        .testTarget(
            name: "AudiobookshelfAPITests",
            dependencies: [
                "AudiobookshelfInterface",
                "AudiobookshelfModel",
                "AudiobookshelfSocket",
                "AudiobookshelfService",
            ]
        ),
    ]
)
