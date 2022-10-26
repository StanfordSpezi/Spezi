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
        .library(name: "SecureStorage", targets: ["SecureStorage"])
    ],
    targets: [
        .target(
            name: "CardinalKit"
        ),
        .target(
            name: "SecureStorage",
            dependencies: [
                .target(name: "CardinalKit")
            ]
        ),
        .target(
            name: "XCTCardinalKit",
            dependencies: [
                .target(name: "CardinalKit")
            ]
        ),
        .testTarget(
            name: "CardinalKitTests",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "XCTCardinalKit")
            ]
        )
    ]
)
