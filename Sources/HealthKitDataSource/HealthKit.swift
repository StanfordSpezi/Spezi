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
public final class HealthKit<ComponentStandard: Standard>: Component, ObservableObject, ObservableObjectProvider {
    /// <#Description#>
    public typealias Adapter = any DataSourceRegistryAdapter<HKSample, ComponentStandard.BaseType>
    
    
    @StandardActor var standard: ComponentStandard
    
    let healthStore: HKHealthStore
    let healthKitDataSourceDescriptions: [HealthKitDataSourceDescription]
    let adapter: Adapter
    lazy var healthKitComponents: [any HealthKitDataSource] = {
        healthKitDataSourceDescriptions
            .map { $0.dataSource(healthStore: healthStore, standard: standard, adapter: adapter) }
    }()
    
    
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
        
        for healthKitComponent in healthKitComponents {
            healthKitComponent.askedForAuthorization()
        }
    }
    
    
    /// <#Description#>
    public func triggerDataSourceCollection() async {
        await withTaskGroup(of: Void.self) { group in
            for healthKitComponent in healthKitComponents {
                group.addTask {
                    await healthKitComponent.triggerDataSourceCollection()
                }
            }
            await group.waitForAll()
        }
    }
}
