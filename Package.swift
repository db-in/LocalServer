import PackageDescription

let package = Package(
    name: "LocalServer",
    products: [
        .library(
            name: "LocalServer",
            targets: ["LocalServer"]
        ),
    ],
    targets: [
        .target(
            name: "LocalServer",
            dependencies: []
        ),
        .testTarget(
            name: "LocalServerTests",
            dependencies: ["LocalServer"]
        ),
    ]
)
