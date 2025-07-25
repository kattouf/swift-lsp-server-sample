// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-lsp-server-sample",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "swift-lsp-server-sample", targets: ["SwiftLSPServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/ChimeHQ/LanguageServerProtocol", from: "0.14.0"),
        .package(url: "https://github.com/ChimeHQ/LanguageServer", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "510.0.1"),
        .package(url: "https://github.com/swiftlang/swift-package-manager", revision: "1fc90e29029bfeafe3550ccf08f74a86a11baa23"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", from: "1.3.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.3"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftLSPServer",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "LanguageServerProtocol", package: "LanguageServerProtocol"),
                .product(name: "LanguageServer", package: "LanguageServer"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftPMDataModel-auto", package: "swift-package-manager"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
    ]
)
