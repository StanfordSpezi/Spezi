// swift-tools-version:5.7

//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "CardinalKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "Account", targets: ["Account"]),
        .library(name: "CardinalKit", targets: ["CardinalKit"]),
        .library(name: "Contact", targets: ["Contact"]),
        .library(name: "FHIR", targets: ["FHIR"]),
        .library(name: "HealthKitDataSource", targets: ["HealthKitDataSource"]),
        .library(name: "LocalStorage", targets: ["LocalStorage"]),
        .library(name: "SecureStorage", targets: ["SecureStorage"]),
        .library(name: "XCTRuntimeAssertions", targets: ["XCTRuntimeAssertions"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/FHIRModels", .upToNextMinor(from: "0.4.0"))
    ],
    targets: [
        .target(
            name: "Account",
            dependencies: [
                .target(name: "CardinalKit")
            ],
            resources: [
                .process("Resources")
            ]
        ),
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
            name: "Contact",
            dependencies: [
                .target(name: "CardinalKit")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "FHIR",
            dependencies: [
                .target(name: "CardinalKit"),
                .product(name: "ModelsR4", package: "FHIRModels")
            ]
        ),
        .testTarget(
            name: "FHIRTests",
            dependencies: [
                .target(name: "FHIR")
            ]
        ),
        .target(
            name: "HealthKitDataSource",
            dependencies: [
                .target(name: "CardinalKit")
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
            name: "SecureStorage",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "XCTRuntimeAssertions")
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
