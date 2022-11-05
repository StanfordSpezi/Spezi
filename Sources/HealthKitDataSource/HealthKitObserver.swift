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


public actor HealthKitObserver<ComponentStandard: Standard>: Component, LifecycleHandler {
    @Dependency var healthKitHealthStoreComponent = HealthKitHealthStore()
    var activeObservations: [HKObjectType: Int] = [:]
    
    
    var healthStore: HKHealthStore {
        healthKitHealthStoreComponent.healthStore
    }
    
    
    public init() {}
    
    
    public func startObservation(
        for sampleTypes: Set<HKSampleType>,
        predicate: NSPredicate? = nil
    ) -> AsyncThrowingStream<(Set<HKSampleType>, HKObserverQueryCompletionHandler), Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    try await enableBackgroundDelivery(for: sampleTypes)
                } catch {
                    continuation.finish(throwing: error)
                }
                
                var queryDescriptors: [HKQueryDescriptor] = []
                for sampleType in sampleTypes {
                    queryDescriptors.append(
                        HKQueryDescriptor(sampleType: sampleType, predicate: predicate ?? healthKitHealthStoreComponent.predicateStarting())
                    )
                }
                
                let observerQuery = HKObserverQuery(queryDescriptors: queryDescriptors) { _, samples, completionHandler, error in
                    guard error == nil,
                          let samples else {
                        continuation.finish(throwing: error)
                        completionHandler()
                        return
                    }
                    
                    continuation.yield((samples, completionHandler))
                }
                
                healthStore.execute(observerQuery)
                
                continuation.onTermination = { @Sendable _ in
                    Task {
                        await self.healthStore.stop(observerQuery)
                        await self.disableBackgroundDelivery(for: sampleTypes)
                    }
                }
            }
        }
    }
    
    
    private func enableBackgroundDelivery(for objectTypes: Set<HKObjectType>) async throws {
        try await healthStore.requestAuthorization(toShare: [], read: objectTypes as Set<HKObjectType>)
        
        var enabledObjectTypes: Set<HKObjectType> = []
        do {
            for objectType in objectTypes {
                try await healthStore.enableBackgroundDelivery(for: objectType, frequency: .immediate)
                enabledObjectTypes.insert(objectType)
                activeObservations[objectType] = activeObservations[objectType, default: 0] + 1
            }
        } catch {
            // Revert all changes as enable background delivery for the object types failed.
            disableBackgroundDelivery(for: enabledObjectTypes)
        }
    }
    
    private func disableBackgroundDelivery(for objectTypes: Set<HKObjectType>) {
        for objectType in objectTypes {
            if let activeObservation = self.activeObservations[objectType] {
                let newActiveObservation = activeObservation - 1
                if newActiveObservation <= 0 {
                    self.activeObservations[objectType] = nil
                    Task {
                        try await self.healthStore.disableBackgroundDelivery(for: objectType)
                    }
                } else {
                    self.activeObservations[objectType] = newActiveObservation
                }
            }
        }
    }
}
