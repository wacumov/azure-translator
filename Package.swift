// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AzureTranslator",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(
            name: "AzureTranslator",
            targets: ["AzureTranslator"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AzureTranslator",
            dependencies: []
        ),
        .testTarget(
            name: "AzureTranslatorTests",
            dependencies: ["AzureTranslator"]
        ),
    ]
)
