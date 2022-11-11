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
public class HealthKit<ComponentStandard: Standard>: Component, ObservableObject, ObservableObjectComponent {
    /// <#Description#>
    public typealias Adapter = any DataSourceRegistryAdapter<HKSample, ComponentStandard.BaseType>
    
    
    let healthStore: HKHealthStore
    let healthKitDataSourceDescriptions: [HealthKitDataSourceDescription]
    let adapter: Adapter
    @DynamicDependencies var healthKitComponents: [any Component<ComponentStandard>]
    
    
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
        var sampleTypes: Set<HKSampleType> = []
        
        for healthKitDataSourceDescription in healthKitDataSourceDescriptions {
            sampleTypes = sampleTypes.union(healthKitDataSourceDescription.sampleTypes)
        }
        
        let requestedSampleTypes = Set(UserDefaults.standard.stringArray(forKey: UserDefaults.Keys.healthKitRequestedSampleTypes) ?? [])
        guard !Set(sampleTypes.map { $0.identifier }).isSubset(of: requestedSampleTypes) else {
            return
        }
        
        try await healthStore.requestAuthorization(toShare: [], read: sampleTypes)
        
        UserDefaults.standard.set(sampleTypes.map { $0.identifier }, forKey: UserDefaults.Keys.healthKitRequestedSampleTypes)
        
        for healthKitComponent in healthKitComponents.compactMap({ $0 as? (any HealthKitComponent) }) {
            healthKitComponent.askedForAuthorization()
        }
    }
    
    
    /// <#Description#>
    public func triggerDataSourceCollection() async {
        await withTaskGroup(of: Void.self) { group in
            for healthKitComponent in healthKitComponents.compactMap({ $0 as? (any HealthKitComponent) }) {
                group.addTask {
                    await healthKitComponent.triggerDataSourceCollection()
                }
            }
            await group.waitForAll()
        }
    }
}
