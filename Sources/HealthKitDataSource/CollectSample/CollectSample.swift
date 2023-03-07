//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


/// Collects a specificied `HKSampleType`  in the ``HealthKit`` component.
public struct CollectSample: HealthKitDataSourceDescription {
    private let collectSamples: CollectSamples
    
    
    public var sampleTypes: Set<HKSampleType> {
        collectSamples.sampleTypes
    }
    
    
    /// - Parameters:
    ///   - sampleType: The `HKSampleType` that should be collected
    ///   - deliverySetting: The ``HealthKitDeliverySetting`` that should be used to collect the sample type. `.manual` is the default argument used.
    public init<S: HKSampleType>(_ sampleType: S, deliverySetting: HealthKitDeliverySetting = .manual()) {
        self.collectSamples = CollectSamples([sampleType], deliverySetting: deliverySetting)
    }
    
    
    public func dataSources<S: Standard>(
        healthStore: HKHealthStore,
        standard: S,
        adapter: HealthKit<S>.HKSampleAdapter
    ) -> [any HealthKitDataSource] {
        collectSamples.dataSources(healthStore: healthStore, standard: standard, adapter: adapter)
    }
}
