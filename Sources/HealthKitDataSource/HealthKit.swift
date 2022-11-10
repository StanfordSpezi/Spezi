//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


public protocol HealthKitDataSourceDescription {
    func dependency<S: Standard>(healthStore: HKHealthStore, adapter: HealthKit<S>.Adapter) -> any ComponentDependency<S>
}


public struct Collect<SampleType: HKSampleType>: HealthKitDataSourceDescription {
    let sampleType: SampleType
    let deliverySetting: HealthKitDeliverySetting
    
    
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


public class HealthKit<ComponentStandard: Standard>: Component {
    public typealias Adapter = any DataSourceRegistryAdapter<HKSample, ComponentStandard.BaseType>
    
    
    let healthStore: HKHealthStore
    let adapter: Adapter
    @DynamicDependencies var healthKitComponents: [any Component<ComponentStandard>]
    
    
    public init(
        _ healthKitDataSourceDescriptions: [HealthKitDataSourceDescription],
        @DataSourceRegistryAdapterBuilder<ComponentStandard> _ adapter: () -> (Adapter)
    ) {
        precondition(
            HKHealthStore.isHealthDataAvailable(),
            """
            HealthKit is not available on this device.
            Check if HealthKit is available e.g., using `HKHealthStore.isHealthDataAvailable()`:
            
            if HKHealthStore.isHealthDataAvailable() {
                HealthKitHealthStore()
            }
            """
        )
        
        let healthStore = HKHealthStore()
        let adapter = adapter()
        
        self._healthKitComponents = DynamicDependencies(
            componentProperties: healthKitDataSourceDescriptions
                .map {
                    $0.dependency(healthStore: healthStore, adapter: adapter)
                }
        )
        self.adapter = adapter
        self.healthStore = healthStore
    }
}
