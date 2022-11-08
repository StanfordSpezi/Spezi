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
    func dependency<S: Standard>(healthStore: HKHealthStore) -> any ComponentProperty<S>
}


public struct Collect<SampleType: CorrelatingSampleType>: HealthKitDataSourceDescription {
    let type: SampleType
    let deliverySetting: HealthKitDeliverySetting
    
    
    public init(type: SampleType, deliverySetting: HealthKitDeliverySetting = .manual) {
        self.type = type
        self.deliverySetting = deliverySetting
    }


    public func dependency<S: Standard>(healthStore: HKHealthStore) -> any ComponentProperty<S> {
        fatalError("Not implemented")
    }
}

//public struct CollectECG: HealthKitDataSourceDescription {
//    let autoStart: Bool
//
//
//    public init(autoStart: Bool = false) {
//        self.autoStart = autoStart
//    }
//
//
//    public func component<ComponentStandard: Standard>(_ standard: ComponentStandard.Type = ComponentStandard.self) -> any Component {
//        ECGHealthKitDataSource<ComponentStandard>(autoStart: true)
//    }
//}


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
        
        self.adapter = adapter()
        self._healthKitComponents = DynamicDependencies(
            componentProperties: healthKitDataSourceDescriptions.map { $0.dependency(healthStore: healthStore) }
        )
        self.healthStore = healthStore
    }
}
