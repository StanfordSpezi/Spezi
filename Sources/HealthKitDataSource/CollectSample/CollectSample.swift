//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


/// <#Description#>
public struct CollectSample<SampleType: HKSampleType>: HealthKitDataSourceDescription {
    let sampleType: SampleType
    let deliverySetting: HealthKitDeliverySetting
    
    
    public var sampleTypes: Set<HKSampleType> {
        [sampleType]
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - sampleType: <#sampleType description#>
    ///   - deliverySetting: <#deliverySetting description#>
    public init(_ sampleType: SampleType, deliverySetting: HealthKitDeliverySetting = .manual()) {
        self.sampleType = sampleType
        self.deliverySetting = deliverySetting
    }
    
    
    public func dataSource<S: Standard>(healthStore: HKHealthStore, standard: S, adapter: HealthKit<S>.Adapter) -> HealthKitDataSource {
        HealthKitSampleDataSource<S, SampleType>(
            healthStore: healthStore,
            standard: standard,
            sampleType: sampleType,
            deliverySetting: deliverySetting,
            adapter: adapter
        )
    }
}
