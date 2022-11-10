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
public class HealthKit<ComponentStandard: Standard>: Component {
    /// <#Description#>
    public typealias Adapter = any DataSourceRegistryAdapter<HKSample, ComponentStandard.BaseType>
    
    
    let healthStore: HKHealthStore
    let adapter: Adapter
    @DynamicDependencies var healthKitComponents: [any Component<ComponentStandard>]
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - healthKitDataSourceDescriptions: <#healthKitDataSourceDescriptions description#>
    ///   - adapter: <#adapter description#>
    public init(
        _ healthKitDataSourceDescriptions: [HealthKitDataSourceDescription],
        @DataSourceRegistryAdapterBuilder<ComponentStandard> adapter: () -> (Adapter)
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
