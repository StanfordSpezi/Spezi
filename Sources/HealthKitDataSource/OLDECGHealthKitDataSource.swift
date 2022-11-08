//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import AsyncAlgorithms
import CardinalKit
import HealthKit
import SwiftUI


enum SampleType {
    case electrocardiogram
    
    var sampleType: HKSampleType {
        switch self {
        case .electrocardiogram:
            return HKSampleType.electrocardiogramType()
        }
    }
}

enum HealthKitType {
    case sample(SampleType)
    
    
    var sampleType: HKObjectType {
        switch self {
        case let .sample(sampleType):
            return sampleType.sampleType as HKObjectType
        }
    }
}

// protocol DataSource {
//    associatedtype Data
//    associatedtype DataSourceError: Error = Never
//
//    typealias DataStream = AsyncThrowingStream<Data, DataSourceError>
//
//
//    var dataSource: DataStream { get }
// }

enum HealthKitDataSourceError: Error {
    case healthDataIsNotAvailable
}

public class OLDECGHealthKitDataSource<ComponentStandard: Standard>: Component, LifecycleHandler {
    typealias DataStream = AsyncThrowingStream<HKElectrocardiogram, Error>
    
    
    private let healthStore = HKHealthStore()
    private let typeToRead: HKObjectType
    private var anchor: HKQueryAnchor?
    private var continuation: DataStream.Continuation?
    private var queryTask: Task<Void, Error>?
    private(set) var dataSource: DataStream
    
    
    /// Creates a new instance of ``HealthKitDataSource``.
    /// - Parameter types: A `Set` of `HKObjectType`s that the `HealthKitDataSource` should collect.
    /// - Parameter deliver: The delivery mode of the ``HealthKitDataSource`` as defined by the ``HealthKitDataDelivery`` enum.
    public required init() {
        guard HKHealthStore.isHealthDataAvailable() else {
            preconditionFailure(
                """
                HealthKit is not available on this device.
                Check if HealthKit is available e.g., using `HealthKitDataSource.isAvailable`:
                
                if HKHealthStore.isHealthDataAvailable() {
                    HealthKitDataSource()
                }
                """
            )
        }
        
        typeToRead = HKObjectType.electrocardiogramType()
        
        
        // We initalize the dataSequence and immediatly override it to ensure that is does not contain an optional value.
        dataSource = AsyncThrowingStream { _ in }
        dataSource = AsyncThrowingStream { continuation in
            self.continuation = continuation
        }
    }
    
    public func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: [
                    HKObjectType.categoryType(forIdentifier: .rapidPoundingOrFlutteringHeartbeat)!,
                    HKObjectType.categoryType(forIdentifier: .skippedHeartbeat)!,
                    HKObjectType.categoryType(forIdentifier: .fatigue)!,
                    HKObjectType.categoryType(forIdentifier: .shortnessOfBreath)!,
                    HKObjectType.categoryType(forIdentifier: .chestTightnessOrPain)!,
                    HKObjectType.categoryType(forIdentifier: .fainting)!,
                    HKObjectType.categoryType(forIdentifier: .dizziness)!
                ])
                
                let backgroundSamples = backgroundQuery(
                    for: [
                        .electrocardiogramType()
                    ],
                    corrolatingObjectType: [
                        .electrocardiogramType()
                    ]
                )
                
                for try await (_, completionHandler) in backgroundSamples {
                    Task {
                        await self.queryForElectrocardiogramType()
                        completionHandler()
                    }
                }
            } catch {
                print(error)
                continuation?.finish(throwing: error)
            }
        }
    }
    
    func backgroundQuery(
        for sampleTypes: Set<HKSampleType>,
        corrolatingObjectType objectTypes: Set<HKObjectType>
    ) -> AsyncThrowingStream<(Set<HKSampleType>, HKObserverQueryCompletionHandler), Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    try await healthStore.requestAuthorization(toShare: [], read: objectTypes)
                    for objectType in objectTypes {
                        try await healthStore.enableBackgroundDelivery(for: objectType, frequency: .immediate)
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
                
                let fromNow = HKQuery.predicateForSamples(
                    withStart: Date(),
                    end: nil,
                    options: [
                        .strictStartDate
                    ]
                )
                
                let queryDescriptor = HKQueryDescriptor(sampleType: .electrocardiogramType(), predicate: fromNow)
                
                let observerQuery = HKObserverQuery(queryDescriptors: [queryDescriptor]) { _, samples, completionHandler, error in
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
                    self.healthStore.stop(observerQuery)
                    Task {
                        for objectType in objectTypes {
                            try await self.healthStore.disableBackgroundDelivery(for: objectType)
                        }
                    }
                }
            }
        }
    }
    
    func queryForElectrocardiogramType() async {
        let fromNow = HKQuery.predicateForSamples(
            withStart: Date(),
            end: nil,
            options: [
                .strictStartDate
            ]
        )
        
        // Create the descriptor.
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.sample(type: .electrocardiogramType(), predicate: fromNow)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 10
        )

        do {
            // Launch the query and wait for the results.
            // The system automatically sets results to [HKQuantitySample].
            let results = try await descriptor.result(for: self.healthStore)

            for result in results.compactMap({ $0 as? HKElectrocardiogram }) {
                continuation?.yield(result)
                
                print("NumberOfVoltageMeasurements: \(result.numberOfVoltageMeasurements)")
                print("SymptomsStatus: \(String(describing: result.symptomsStatus))")
                print("Classification: \(String(describing: result.classification))")
        
                let sampleTypes: [HKCategoryType] = [
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.rapidPoundingOrFlutteringHeartbeat)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.skippedHeartbeat)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.fatigue)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.shortnessOfBreath)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.chestTightnessOrPain)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.fainting)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.dizziness)!
                ]
                
                if result.symptomsStatus == .present {
                    for sampleType in sampleTypes {
                        sampleType.identifier
                        let test = HKCategoryTypeIdentifier.rapidPoundingOrFlutteringHeartbeat
                        let aTest = test.rawValue
                        let predicate = HKQuery.predicateForObjectsAssociated(electrocardiogram: result)
                        
                        // Create the descriptor.
                        let sampleQueryDescriptor = HKSampleQueryDescriptor(
                            predicates: [.sample(type: sampleType, predicate: predicate)],
                            sortDescriptors: []
                        )
                        
                        let samples = try await sampleQueryDescriptor.result(for: healthStore)
                        if let categorySamples = samples as? [HKCategorySample] {
                            for categorySample in categorySamples {
                                categorySample.categoryType
                                if let categoryValueSeverity = HKCategoryValueSeverity(rawValue: categorySample.value) {
                                    print("\(String(describing: sampleType)): \(String(describing: categoryValueSeverity))")
                                } else {
                                    print("\(String(describing: sampleType)): \(String(describing: categorySample))")
                                }
                            }
                        } else {
                            print("\(String(describing: sampleType)): \(String(describing: samples))")
                        }
                    }
                }
                
                let electrocardiogramQueryDescriptor = HKElectrocardiogramQueryDescriptor(result)
                for try await measurement in electrocardiogramQueryDescriptor.results(for: self.healthStore) {
                    if let voltageQuantity = measurement.quantity(for: .appleWatchSimilarToLeadI) {
                        print("Voltage: \(measurement.timeSinceSampleStart) - \(voltageQuantity)")
                    }
                }
            }
        } catch {
            continuation?.finish(throwing: error)
        }
    }
    
    func runAnchoredQuery() {
        let anchorDescriptor = HKAnchoredObjectQueryDescriptor(
            predicates: [
                .electrocardiogram()
            ],
            anchor: anchor
        )

        // Start a long-running query to monitor the HealthKit store.
        let updateQueue = anchorDescriptor.results(for: healthStore)

        // Wait for the initial results and each update.
        self.queryTask = Task {
            do {
                for try await results in updateQueue {
                    // Process the results.
                    let addedSamples = results.addedSamples
                    let deletedSamples = results.deletedObjects
                    for addedSample in addedSamples {
                        continuation?.yield(addedSample)
                    }
                    anchor = results.newAnchor

                    print("- \(addedSamples.count) new electrocardiograms found.\n")
                    print("- \(deletedSamples.count) deleted electrocardiograms found.\n")
                }
            } catch {
                print(error)
                continuation?.finish(throwing: error)
            }
        }

        continuation?.onTermination = { @Sendable _ in
            self.queryTask?.cancel()
            self.queryTask = nil
        }
    }
}
