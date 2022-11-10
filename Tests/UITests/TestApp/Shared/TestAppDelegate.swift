//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit
import HealthKitDataSource
import LocalStorage
import SecureStorage
import SwiftUI


class TestAppDelegate: CardinalKitAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: TestAppStandard()) {
            ObservableComponentTestsComponent(message: "Passed")
            if HKHealthStore.isHealthDataAvailable() {
                HealthKit {
                    Collect(
                        sampleType: HKQuantityType.electrocardiogramType(),
                        deliverySetting: .background(.manual)
                    )
                    Collect(
                        sampleType: HKQuantityType(.stepCount),
                        deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
                    )
                    Collect(
                        sampleType: HKQuantityType(.vo2Max),
                        deliverySetting: .anchorQuery(.manual)
                    )
                    Collect(
                        sampleType: HKQuantityType(.activeEnergyBurned),
                        deliverySetting: .anchorQuery(.afterAuthorizationAndApplicationWillLaunch)
                    )
                    Collect(
                        sampleType: HKQuantityType(.heartRate),
                        deliverySetting: .manual
                    )
                } adapter: {
                    TestAppHealthKitAdapter()
                }
            }
            SecureStorage()
            LocalStorage()
        }
    }
}
