// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "LocalServer",
    products: [
        .library(
            name: "LocalServer",
            targets: ["LocalServer"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LocalServer",
            dependencies: [],
            path: "LocalServer/Source",
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("GENERATE_INFOPLIST_FILE")
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("WebKit", .when(platforms: [.iOS]))
            ]
        ),
        .testTarget(
            name: "LocalServerTests",
            dependencies: ["LocalServer"],
            path: "LocalServerTests"
        )
    ]
)
