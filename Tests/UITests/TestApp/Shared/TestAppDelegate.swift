//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
@preconcurrency import FHIR
import FHIRMockDataStorageProvider
import FirebaseAccount
import FirestoreDataStorage
@preconcurrency import HealthKit
import HealthKitDataSource
import HealthKitToFHIRAdapter
import LocalStorage
import SecureStorage
import SwiftUI


class TestAppDelegate: CardinalKitAppDelegate {
    override var configuration: Configuration {
        if CommandLine.arguments.contains("--fhirTests") {
            return Configuration(standard: FHIR()) {
                MockDataStorageProvider()
                if HKHealthStore.isHealthDataAvailable() {
                    HealthKit {
                        CollectSample(
                            HKQuantityType(.stepCount),
                            deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
                        )
                    } adapter: {
                        HealthKitToFHIRAdapter()
                    }
                }
            }
        } else {
            return Configuration(standard: TestAppStandard()) {
                Firestore(settings: .emulator)
                if CommandLine.arguments.contains("--firebaseAccount") {
                    FirebaseAccountConfiguration(emulatorSettings: (host: "localhost", port: 9099))
                } else {
                    TestAccountConfiguration()
                }
                if HKHealthStore.isHealthDataAvailable() {
                    healthKit
                }
                LocalStorage()
                MultipleObservableObjectsTestsComponent()
                ObservableComponentTestsComponent(message: "Passed")
                SecureStorage()
            }
        }
    }
    
    
    private var healthKit: HealthKit<TestAppStandard> {
        HealthKit<TestAppStandard> {
            CollectSample(
                HKQuantityType.electrocardiogramType(),
                deliverySetting: .background(.manual)
            )
            CollectSample(
                HKQuantityType(.stepCount),
                deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
            )
            CollectSample(
                HKQuantityType(.pushCount),
                deliverySetting: .anchorQuery(.manual)
            )
            CollectSample(
                HKQuantityType(.activeEnergyBurned),
                deliverySetting: .anchorQuery(.afterAuthorizationAndApplicationWillLaunch)
            )
            CollectSample(
                HKQuantityType(.restingHeartRate),
                deliverySetting: .manual()
            )
        } adapter: {
            TestAppHealthKitAdapter()
        }
    }
}
