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
            targets: [
                "AltairMDKCommon",
                "AltairMDKProviders"
            ]),
    ],
    dependencies: [],
    targets: [
        
        .target(
            name: "AltairMDKCommon",
            dependencies: [],
            path: "Sources/Common"),
        
        .target(
            name: "AltairMDKProviders",
            dependencies: [
                "AltairMDKCommon"
            ],
            path: "Sources/Providers"),
        
        .testTarget(
            name: "AltairMDKCommonTests",
            dependencies: [
                "AltairMDKCommon"
            ],
            path: "Tests/CommonTests")
    ]
)
