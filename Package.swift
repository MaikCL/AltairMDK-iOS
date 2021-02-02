// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Altair-MDK",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Altair-MDK",
            targets: ["AltairMDKCommon"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "AltairMDKCommon", dependencies: [], path: "Sources/Common"),
        .testTarget(name: "AltairMDKCommonTests", dependencies: ["AltairMDKCommon"], path: "Tests/CommonTests")
    ]
)
