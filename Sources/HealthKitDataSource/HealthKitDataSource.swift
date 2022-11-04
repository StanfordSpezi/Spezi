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


protocol DataSource {
    associatedtype Data
    associatedtype DataSourceError: Error = Never
    
    typealias DataStream = AsyncThrowingStream<Data, DataSourceError>
    
    
    var dataSequence: DataStream { get }
}

enum HealthKitDataSourceError: Error {
    case healthDataIsNotAvailable
}

public class HealthKitDataSource<ComponentStandard: Standard>: Component, LifecycleHandler, DataSource {
    typealias DataStream = AsyncThrowingStream<HKElectrocardiogram, Error>
    
    
    private let healthStore = HKHealthStore()
    private let typeToRead: HKObjectType
    private var anchor: HKQueryAnchor? = nil
    private var continuation: DataStream.Continuation? = nil
    private var queryTask: Task<Void, Error>? = nil
    private(set) var dataSequence: DataStream
    
    
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
        dataSequence = AsyncThrowingStream { _ in }
        dataSequence = AsyncThrowingStream { continuation in
            self.continuation = continuation
            
            continuation.onTermination = { @Sendable _ in
                self.queryTask?.cancel()
                self.queryTask = nil
            }
        }
    }
    
    public func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]) {
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: [typeToRead])
                try await healthStore.requestAuthorization(toShare: [], read: [
                    HKObjectType.categoryType(forIdentifier: .rapidPoundingOrFlutteringHeartbeat)!,
                    HKObjectType.categoryType(forIdentifier: .skippedHeartbeat)!,
                    HKObjectType.categoryType(forIdentifier: .fatigue)!,
                    HKObjectType.categoryType(forIdentifier: .shortnessOfBreath)!,
                    HKObjectType.categoryType(forIdentifier: .chestTightnessOrPain)!,
                    HKObjectType.categoryType(forIdentifier: .fainting)!,
                    HKObjectType.categoryType(forIdentifier: .dizziness)!
                ])
                try await healthStore.enableBackgroundDelivery(for: typeToRead, frequency: .immediate)
            } catch {
                print(error)
                continuation?.finish(throwing: error)
            }
            
            // try await healthStore.enableBackgroundDelivery(for: typeToRead, frequency: .hourly)
            // Get the date one week ago.
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.day = components.day! - 7
            let oneWeekAgo = calendar.date(from: components)

            // Create a predicate for all samples within the last week.
            let inLastWeek = HKQuery.predicateForSamples(
                withStart: oneWeekAgo,
                end: nil,
                options: [
                    .strictStartDate
                ]
            )
            
            // Create the query descriptor.
            let queryDescriptor = HKQueryDescriptor(sampleType: .electrocardiogramType(), predicate: inLastWeek)
            
            let observerQuery = HKObserverQuery(queryDescriptors: [queryDescriptor]) { observerQuery, samples, completionHandler, error in
                guard error == nil else {
                    self.healthStore.stop(observerQuery)
                    self.continuation?.finish(throwing: error)
                    completionHandler()
                    return
                }
                
                self.queryForElectrocardiogramType(completionHandler: completionHandler)
            }
            healthStore.execute(observerQuery)
            
            continuation?.onTermination = { @Sendable _ in
                self.queryTask?.cancel()
                self.queryTask = nil
            }
        }
    }
    
    func queryForElectrocardiogramType(completionHandler: @escaping HKObserverQueryCompletionHandler) {
        // Create the descriptor.
        let descriptor = HKSampleQueryDescriptor(
            predicates:[.sample(type: .electrocardiogramType())],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 10
        )

        Task {
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
                            let predicate = HKQuery.predicateForObjectsAssociated(electrocardiogram: result)
                            
                            // Create the descriptor.
                            let sampleQueryDescriptor = HKSampleQueryDescriptor(
                                predicates:[.sample(type: sampleType, predicate: predicate)],
                                sortDescriptors: []
                            )
                            
                            let samples = try await sampleQueryDescriptor.result(for: healthStore)
                            if let categorySamples = samples as? [HKCategorySample] {
                                for categorySample in categorySamples {
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
            
            completionHandler()
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
