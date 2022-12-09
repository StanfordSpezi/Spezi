//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


extension HKHealthStore {
    static var activeObservations: [HKObjectType: Int] = [:]
    
    
    func startObservation(
        for sampleTypes: Set<HKSampleType>,
        withPredicate predicate: NSPredicate? = nil
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
                        HKQueryDescriptor(sampleType: sampleType, predicate: predicate)
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
                
                self.execute(observerQuery)
                
                continuation.onTermination = { @Sendable _ in
                    self.stop(observerQuery)
                    Task {
                        await self.disableBackgroundDelivery(for: sampleTypes)
                    }
                }
            }
        }
    }
    
    
    func enableBackgroundDelivery(
        for objectTypes: Set<HKObjectType>,
        frequency: HKUpdateFrequency = .immediate
    ) async throws {
        try await self.requestAuthorization(toShare: [], read: objectTypes as Set<HKObjectType>)
        
        var enabledObjectTypes: Set<HKObjectType> = []
        do {
            for objectType in objectTypes {
                try await self.enableBackgroundDelivery(for: objectType, frequency: frequency)
                enabledObjectTypes.insert(objectType)
                HKHealthStore.activeObservations[objectType] = HKHealthStore.activeObservations[objectType, default: 0] + 1
            }
        } catch {
            // Revert all changes as enable background delivery for the object types failed.
            await disableBackgroundDelivery(for: enabledObjectTypes)
        }
    }
    
    
    func disableBackgroundDelivery(
        for objectTypes: Set<HKObjectType>
    ) async {
        for objectType in objectTypes {
            if let activeObservation = HKHealthStore.activeObservations[objectType] {
                let newActiveObservation = activeObservation - 1
                if newActiveObservation <= 0 {
                    HKHealthStore.activeObservations[objectType] = nil
                    do {
                        try await self.disableBackgroundDelivery(for: objectType)
                    } catch {}
                } else {
                    HKHealthStore.activeObservations[objectType] = newActiveObservation
                }
            }
        }
    }
}
