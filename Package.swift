// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "AudiobookshelfAPI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
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
//        .package(
//            url: "https://github.com/JamesRagnar/RagnarNetworking",
//            branch: "main"
//        )
        .package(path: "../RagnarNetworking")
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
