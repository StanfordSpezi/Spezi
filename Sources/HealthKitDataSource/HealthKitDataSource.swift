//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


class HealthKitDataSource<ComponentStandard: Standard, SampleType: CorrelatingSampleType>: Component, DataSource {
    typealias DataStream = AsyncThrowingStream<SampleType.Sample, Error>
    
    @Dependency var healthKitHealthStoreComponent = HealthKitHealthStore()
    private let sampleType: SampleType
    private var anchor: HKQueryAnchor? = nil
    private var continuation: DataStream.Continuation? = nil
    private var queryTask: Task<Void, Error>? = nil
    private(set) var dataSource: DataStream
    
    
    var healthStore: HKHealthStore {
        healthKitHealthStoreComponent.healthStore
    }
    
    
    init(sampleType: SampleType) {
        self.sampleType = sampleType
        
        // We initalize the dataSource and immediatly override it to ensure that is does not contain an optional value.
        dataSource = AsyncThrowingStream { _ in }
        dataSource = AsyncThrowingStream { continuation in
            self.continuation = continuation
        }
    }
    
    
    func beginDataDelivery(
        predicate: NSPredicate? = nil
    ) async {
        let anchorDescriptor = HKAnchoredObjectQueryDescriptor(
            predicates: [
                .sample(type: sampleType, predicate: predicate ?? healthKitHealthStoreComponent.predicateStarting())
            ],
            anchor: anchor
        )
        
        // Start a long-running query to monitor the HealthKit store.
        let updateQueue = anchorDescriptor.results(for: healthStore)
        
        // Wait for the initial results and each update.
        self.queryTask = Task {
            do {
                for try await results in updateQueue {
                    if Task.isCancelled {
                        break
                    }
                    
                    for addedSample in results.addedSamples {
                        if let addedSample = addedSample as? SampleType.Sample {
                            continuation?.yield(addedSample)
                        } else {
                            continuation?.finish()
                        }
                    }
                    anchor = results.newAnchor
                }
            } catch {
                continuation?.finish(throwing: error)
            }
        }
        
        continuation?.onTermination = { @Sendable _ in
            self.queryTask?.cancel()
            self.queryTask = nil
        }
    }
    
    
    func data<SampleType: CorrelatingSampleType>(
        for sampleType: SampleType,
        predicate: NSPredicate? = nil
    ) async throws -> [SampleType.Sample] {
        // Create the descriptor.
        let sampleQueryDescriptor = HKSampleQueryDescriptor(
            predicates:[
                .sample(type: sampleType, predicate: predicate ?? healthKitHealthStoreComponent.predicateStarting())
            ],
            sortDescriptors: [
                SortDescriptor(\.endDate, order: .reverse)
            ]
        )
        
        let samples = try await sampleQueryDescriptor.result(for: healthStore)
        return samples as? [SampleType.Sample] ?? []
    }
}
