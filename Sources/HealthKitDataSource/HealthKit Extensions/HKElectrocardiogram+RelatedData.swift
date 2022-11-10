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


extension HKElectrocardiogram {
    typealias Symptoms = [HKCategoryType: HKCategoryValueSeverity]
    typealias VoltageMeasurements = [(TimeInterval, HKQuantity)]
    
    
    func symptoms(from healthStore: HKHealthStore) async throws -> Symptoms {
        let predicate = HKQuery.predicateForObjectsAssociated(electrocardiogram: self)
        
        // We disable the SwiftLint force unwrap rule here as all initializers use Apple's constants.
        // swiftlint:disable force_unwrapping
        let sampleTypes: [HKCategoryType] = [
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.rapidPoundingOrFlutteringHeartbeat)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.skippedHeartbeat)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.fatigue)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.shortnessOfBreath)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.chestTightnessOrPain)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.fainting)!,
            HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.dizziness)!
        ]
        // swiftlint:enable force_unwrapping
        
        var symptoms: Symptoms = [:]
        
        if symptomsStatus == .present {
            for sampleType in sampleTypes {
                guard let sample = try await healthStore.sampleQuery(for: sampleType, withPredicate: predicate).first,
                      let categorySample = sample as? HKCategorySample else {
                    continue
                }
                symptoms[categorySample.categoryType] = HKCategoryValueSeverity(rawValue: categorySample.value)
            }
        }
        
        return symptoms
    }
    
    func voltageMeasurements(from healthStore: HKHealthStore) async throws -> VoltageMeasurements {
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
