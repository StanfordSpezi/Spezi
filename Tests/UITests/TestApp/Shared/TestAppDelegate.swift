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
                HealthKit(
                    [
                        Collect(type: HKQuantityType.electrocardiogramType())
                    ]
                )
            }
            SecureStorage()
            LocalStorage()
        }
    }
}
