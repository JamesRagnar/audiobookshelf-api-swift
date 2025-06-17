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
            targets: ["AudiobookshelfAPI"]
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
            name: "AudiobookshelfAPI",
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
            ]
        ),
    ]
)
