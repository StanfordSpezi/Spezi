//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit
import SwiftUI


extension HKElectrocardiogram {
    /// A type alias used to associate symptoms in an `HKElectrocardiogram`.
    public typealias Symptoms = [HKCategoryType: HKCategoryValueSeverity]
    /// A type alias used to associate voltage measurements in an `HKElectrocardiogram`.
    public typealias VoltageMeasurements = [(TimeInterval, HKQuantity)]
    
    
    /// All possible `HKCategoryType`s (`HKCategoryTypeIdentifier`s) that can be associated with an `HKElectrocardiogram`.
    public static let correlatedSymptomTypes: [HKCategoryType] = {
        // We disable the SwiftLint force unwrap rule here as all initializers use Apple's constants.
        // swiftlint:disable force_unwrapping
        [
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.rapidPoundingOrFlutteringHeartbeat)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.skippedHeartbeat)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.fatigue)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.shortnessOfBreath)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.chestTightnessOrPain)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.fainting)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.dizziness)!
        ]
        // swiftlint:enable force_unwrapping
    }()
    
    
    /// Load the symptoms of an `HKElectrocardiogram` instance from an `HKHealthStore` instance.
    /// - Parameter healthStore: The `HKHealthStore` instance that should be used to load the `Symptoms`.
    /// - Returns: The symptoms associated with an `HKElectrocardiogram`.
    public func symptoms(from healthStore: HKHealthStore) async throws -> Symptoms {
        let predicate = HKQuery.predicateForObjectsAssociated(electrocardiogram: self)
        
        try await healthStore.requestAuthorization(toShare: [], read: Set<HKObjectType>(HKElectrocardiogram.correlatedSymptomTypes))
        
        var symptoms: Symptoms = [:]
        
        if symptomsStatus == .present {
            for sampleType in HKElectrocardiogram.correlatedSymptomTypes {
                guard let sample = try await healthStore.sampleQuery(for: sampleType, withPredicate: predicate).first,
                      let categorySample = sample as? HKCategorySample else {
                    continue
                }
                symptoms[categorySample.categoryType] = HKCategoryValueSeverity(rawValue: categorySample.value)
            }
        }
        
        return symptoms
    }
    
    /// Load the voltage measurements of an `HKElectrocardiogram` instance from an `HKHealthStore` instance.
    /// - Parameter healthStore: The `HKHealthStore` instance that should be used to load the `VoltageMeasurements`.
    /// - Returns: The voltage measurements associated with an `HKElectrocardiogram`.
    public func voltageMeasurements(from healthStore: HKHealthStore) async throws -> VoltageMeasurements {
        var voltageMeasurements: VoltageMeasurements = []
        voltageMeasurements.reserveCapacity(numberOfVoltageMeasurements)
        
        let electrocardiogramQueryDescriptor = HKElectrocardiogramQueryDescriptor(self)
        
        for try await measurement in electrocardiogramQueryDescriptor.results(for: healthStore) {
            if let voltageQuantity = measurement.quantity(for: .appleWatchSimilarToLeadI) {
                voltageMeasurements.append((measurement.timeSinceSampleStart, voltageQuantity))
            }
        }
        
        return voltageMeasurements
    }
}
