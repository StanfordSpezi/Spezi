// swift-tools-version:5.7

//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "CardinalKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "CardinalKit", targets: ["CardinalKit"]),
        .library(name: "LocalStorage", targets: ["LocalStorage"]),
        .library(name: "SecureStorage", targets: ["SecureStorage"]),
        .library(name: "XCTRuntimeAssertions", targets: ["XCTRuntimeAssertions"])
    ],
    targets: [
        .target(
            name: "CardinalKit",
            dependencies: [
                .target(name: "XCTRuntimeAssertions")
            ]
        ),
        .testTarget(
            name: "CardinalKitTests",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "XCTRuntimeAssertions")
            ]
        ),
        .target(
            name: "SecureStorage",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "XCTRuntimeAssertions")
            ]
        ),
        .target(
            name: "LocalStorage",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "SecureStorage")
            ]
        ),
        .testTarget(
            name: "LocalStorageTests",
            dependencies: [
                .target(name: "LocalStorage")
            ]
        ),
        .target(
            name: "XCTRuntimeAssertions"
        ),
        .testTarget(
            name: "XCTRuntimeAssertionsTests",
            dependencies: [
                .target(name: "XCTRuntimeAssertions")
            ]
        )
    ]
)
