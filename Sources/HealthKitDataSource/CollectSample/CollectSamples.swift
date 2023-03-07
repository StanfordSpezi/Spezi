//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


/// Collects `HKSampleType`s  in the ``HealthKit`` component.
public struct CollectSamples: HealthKitDataSourceDescription {
    public let sampleTypes: Set<HKSampleType>
    let deliverySetting: HealthKitDeliverySetting
    
    
    /// - Parameters:
    ///   - sampleType: The set of `HKSampleType`s that should be collected
    ///   - deliverySetting: The ``HealthKitDeliverySetting`` that should be used to collect the sample type. `.manual` is the default argument used.
    public init(_ sampleTypes: Set<HKSampleType>, deliverySetting: HealthKitDeliverySetting = .manual()) {
        self.sampleTypes = sampleTypes
        self.deliverySetting = deliverySetting
    }
    
    
    public func dataSources<S: Standard>(
        healthStore: HKHealthStore,
        standard: S,
        adapter: HealthKit<S>.HKSampleAdapter
    ) -> [any HealthKitDataSource] {
        sampleTypes.map { sampleType in
            HealthKitSampleDataSource<S>(
                healthStore: healthStore,
                standard: standard,
                sampleType: sampleType,
                deliverySetting: deliverySetting,
                adapter: adapter
            )
        }
    }
}
