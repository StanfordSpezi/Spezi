// swift-tools-version:5.9

//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "Spezi",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Spezi", targets: ["Spezi"]),
        .library(name: "XCTSpezi", targets: ["XCTSpezi"])
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordSpezi/SpeziFoundation", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/StanfordBDHG/XCTRuntimeAssertions", .upToNextMinor(from: "0.2.5"))
    ],
    targets: [
        .target(
            name: "Spezi",
            dependencies: [
                .product(name: "SpeziFoundation", package: "SpeziFoundation"),
                .product(name: "XCTRuntimeAssertions", package: "XCTRuntimeAssertions")
            ]
        ),
        .target(
            name: "XCTSpezi",
            dependencies: [
                .target(name: "Spezi")
            ]
        ),
        .testTarget(
            name: "SpeziTests",
            dependencies: [
                .target(name: "Spezi"),
                .target(name: "XCTSpezi"),
                .product(name: "XCTRuntimeAssertions", package: "XCTRuntimeAssertions")
            ]
        )
    ]
)
