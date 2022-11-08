//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


public class HealthKitHealthStore<ComponentStandard: Standard>: Component {
    public let healthStore = HKHealthStore()
    
    
    public required init() {
        guard HKHealthStore.isHealthDataAvailable() else {
            preconditionFailure(
                """
                HealthKit is not available on this device.
                Check if HealthKit is available e.g., using `HKHealthStore.isHealthDataAvailable()`:
                
                if HKHealthStore.isHealthDataAvailable() {
                    HealthKitHealthStore()
                }
                """
            )
        }
    }
    
    
    func predicateStarting(_ date: Date = .now) -> NSPredicate {
        HKQuery.predicateForSamples(
            withStart: date,
            end: nil,
            options: [
                .strictStartDate
            ]
        )
    }
}
