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
    targets: [
        .target(
            name: "LocalServer",
            dependencies: [],
            path: "LocalServer/Source"
        ),
        .testTarget(
            name: "LocalServerTests",
            dependencies: ["LocalServer"],
            path: "LocalServerTests"
        )
    ]
)
