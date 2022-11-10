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
public struct Collect<SampleType: HKSampleType>: HealthKitDataSourceDescription {
    let sampleType: SampleType
    let deliverySetting: HealthKitDeliverySetting
    
    
    public var sampleTypes: Set<HKSampleType> {
        [sampleType]
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - sampleType: <#sampleType description#>
    ///   - deliverySetting: <#deliverySetting description#>
    public init(sampleType: SampleType, deliverySetting: HealthKitDeliverySetting = .manual) {
        self.sampleType = sampleType
        self.deliverySetting = deliverySetting
    }


    public func dependency<S: Standard>(healthStore: HKHealthStore, adapter: HealthKit<S>.Adapter) -> any ComponentDependency<S> {
        _DependencyPropertyWrapper(
            wrappedValue: HealthKitDataSource(
                healthStore: healthStore,
                sampleType: sampleType,
                deliverySetting: deliverySetting,
                adapter: adapter
            )
        )
    }
}
