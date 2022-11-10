//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit
import SwiftUI


/// <#Description#>
public class HealthKit<ComponentStandard: Standard>: Component {
    /// <#Description#>
    public typealias Adapter = any DataSourceRegistryAdapter<HKSample, ComponentStandard.BaseType>
    
    
    let healthStore: HKHealthStore
    let healthKitDataSourceDescriptions: [HealthKitDataSourceDescription]
    let adapter: Adapter
    @DynamicDependencies var healthKitComponents: [any Component<ComponentStandard>]
    @AppStorage("CardinalKit.HealthKit.didAskForAuthorization") var didAskForAuthorization = false
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - healthKitDataSourceDescriptions: <#healthKitDataSourceDescriptions description#>
    ///   - adapter: <#adapter description#>
    public init(
        @HealthKitDataSourceDescriptionBuilder _ healthKitDataSourceDescriptions: () -> ([HealthKitDataSourceDescription]),
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
        let healthKitDataSourceDescriptions = healthKitDataSourceDescriptions()
        
        self._healthKitComponents = DynamicDependencies(
            componentProperties: healthKitDataSourceDescriptions
                .map {
                    $0.dependency(healthStore: healthStore, adapter: adapter)
                }
        )
        self.adapter = adapter
        self.healthKitDataSourceDescriptions = healthKitDataSourceDescriptions
        self.healthStore = healthStore
    }
    
    
    /// <#Description#>
    public func askForAuthorization() async throws {
        var dataTypes: Set<HKSampleType> = []
        for healthKitDataSourceDescription in healthKitDataSourceDescriptions {
            dataTypes = dataTypes.union(healthKitDataSourceDescription.sampleTypes)
        }
        
        try await healthStore.requestAuthorization(toShare: [], read: dataTypes)
        
        didAskForAuthorization = true
        
        for healthKitComponent in healthKitComponents.compactMap({ $0 as? (any HealthKitComponent) }) {
            healthKitComponent.askedForAuthorization()
        }
    }
}
