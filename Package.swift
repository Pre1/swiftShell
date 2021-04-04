import PackageDescription

let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.0")),
    ],
    targets: [
        .target(name: "swiftShell", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
        // other targets
    ]
