// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NLTextProcessing",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "NLTextProcessing",
            targets: ["NLTextProcessing"]
        ),
    ],
    targets: [
        .target(
            name: "NLTextProcessing",
            resources: [
                .process("Resources/StopWords/EnStopWords.json"),
                .process("Resources/StopWords/RuStopWords.json"),
            ]
        ),
        .testTarget(
            name: "NLTextProcessingTests",
            dependencies: ["NLTextProcessing"]
        ),
    ]
)
