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
        .library(name: "FHIRMockDataStorageProvider", targets: ["FHIRMockDataStorageProvider"]),
        .library(name: "FHIRToFirestoreAdapter", targets: ["FHIRToFirestoreAdapter"]),
        .library(name: "FirestoreDataStorage", targets: ["FirestoreDataStorage"]),
        .library(name: "FirestoreStoragePrefixUserIdAdapter", targets: ["FirestoreStoragePrefixUserIdAdapter"]),
        .library(name: "FirebaseConfiguration", targets: ["FirebaseConfiguration"]),
        .library(name: "FirebaseAccount", targets: ["FirebaseAccount"]),
        .library(name: "HealthKitDataSource", targets: ["HealthKitDataSource"]),
        .library(name: "HealthKitToFHIRAdapter", targets: ["HealthKitToFHIRAdapter"]),
        .library(name: "LocalStorage", targets: ["LocalStorage"]),
        .library(name: "Onboarding", targets: ["Onboarding"]),
        .library(name: "Scheduler", targets: ["Scheduler"]),
        .library(name: "Questionnaires", targets: ["Questionnaires"]),
        .library(name: "SecureStorage", targets: ["SecureStorage"]),
        .library(name: "Views", targets: ["Views"]),
        .library(name: "XCTRuntimeAssertions", targets: ["XCTRuntimeAssertions"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/FHIRModels", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.3.0"),
        .package(url: "https://github.com/StanfordBDHG/HealthKitOnFHIR", .upToNextMinor(from: "0.2.2")),
        .package(url: "https://github.com/StanfordBDHG/ResearchKit", from: "2.2.8"),
        .package(url: "https://github.com/StanfordBDHG/ResearchKitOnFHIR", .upToNextMinor(from: "0.1.5"))
    ],
    targets: [
        .target(
            name: "Account",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "Views")
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
                .target(name: "CardinalKit"),
                .target(name: "Views")
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
            name: "FirebaseConfiguration",
            dependencies: [
                .target(name: "CardinalKit"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]
        ),
        .target(
            name: "FirebaseAccount",
            dependencies: [
                .target(name: "Account"),
                .target(name: "CardinalKit"),
                .target(name: "FirebaseConfiguration"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ]
        ),
        .target(
            name: "FHIRMockDataStorageProvider",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "FHIR"),
                .target(name: "Views")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "FHIRToFirestoreAdapter",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "FHIR"),
                .target(name: "FirestoreDataStorage")
            ]
        ),
        .testTarget(
            name: "FHIRToFirestoreAdapterTests",
            dependencies: [
                .target(name: "FHIRToFirestoreAdapter"),
                .target(name: "FHIR"),
                .product(name: "ModelsR4", package: "FHIRModels")
            ]
        ),
        .target(
            name: "FirestoreDataStorage",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "FirebaseConfiguration"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
            ]
        ),
        .target(
            name: "FirestoreStoragePrefixUserIdAdapter",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "FirestoreDataStorage"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ]
        ),
        .target(
            name: "HealthKitDataSource",
            dependencies: [
                .target(name: "CardinalKit")
            ]
        ),
        .target(
            name: "HealthKitToFHIRAdapter",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "FHIR"),
                .target(name: "HealthKitDataSource"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "HealthKitOnFHIR", package: "HealthKitOnFHIR")
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
            name: "Onboarding",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "Views")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "Questionnaires",
            dependencies: [
                .target(name: "CardinalKit"),
                .target(name: "FHIR"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "ResearchKitOnFHIR", package: "ResearchKitOnFHIR"),
                .product(name: "FHIRQuestionnaires", package: "ResearchKitOnFHIR"),
                .product(name: "ResearchKit", package: "ResearchKit")
            ]
        ),
        .target(
            name: "Scheduler",
            dependencies: [
                .target(name: "CardinalKit")
            ]
        ),
        .testTarget(
            name: "SchedulerTests",
            dependencies: [
                .target(name: "Scheduler")
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
            name: "Views"
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
