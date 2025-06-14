// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "StronglyTypedID",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "StronglyTypedID",
            targets: ["StronglyTypedID"]
        )
    ],
    dependencies: [
        // Depend on the Swift 6.0 release of SwiftSyntax
        .package(url: "https://github.com/apple/swift-syntax.git", from: "601.0.1")
    ],
    targets: [
        .macro(
            name: "StronglyTypedIDMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "StronglyTypedID",
            dependencies: ["StronglyTypedIDMacros"]
        ),
        .testTarget(
            name: "StronglyTypedIDTests",
            dependencies: [
                "StronglyTypedID",
                "StronglyTypedIDMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        )
    ]
)
