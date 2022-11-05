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


struct Electrocardiogram {
    typealias Symptoms = [HKCategoryType: HKCategoryValueSeverity]
    typealias VoltageMeasurements = [(TimeInterval, HKQuantity)]
    
    
    let hkElectrocardiogram: HKElectrocardiogram
    let symptoms: Symptoms
    let voltageMeasurements: VoltageMeasurements
}


public class ECGHealthKitDataSource<ComponentStandard: Standard>: Component, DataSource, LifecycleHandler {
    typealias DataStream = AsyncThrowingStream<Electrocardiogram, Error>
    
    
    @Dependency var healthKitDataSource = HealthKitDataSource(sampleType: HKObjectType.electrocardiogramType())
    
    
    public init() { }
    
    
    lazy var dataSource: DataStream = {
        AsyncThrowingStream(unfolding: {
            for try await electrocardiogram in self.healthKitDataSource.dataSource {
                let predicate = HKQuery.predicateForObjectsAssociated(electrocardiogram: electrocardiogram)
                
                let sampleTypes: [HKCategoryType] = [
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.rapidPoundingOrFlutteringHeartbeat)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.skippedHeartbeat)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.fatigue)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.shortnessOfBreath)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.chestTightnessOrPain)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.fainting)!,
                    HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.dizziness)!
                ]
                
                var symptoms: Electrocardiogram.Symptoms = [:]
                if electrocardiogram.symptomsStatus == .present {
                    for sampleType in sampleTypes {
                        guard let sample = try await self.healthKitDataSource.data(for: sampleType, predicate: predicate).first else {
                            continue
                        }
                        symptoms[sample.categoryType] = HKCategoryValueSeverity(rawValue: sample.value)
                    }
                }
                
                var voltageMeasurements: Electrocardiogram.VoltageMeasurements = []
                voltageMeasurements.reserveCapacity(electrocardiogram.numberOfVoltageMeasurements)
                let electrocardiogramQueryDescriptor = HKElectrocardiogramQueryDescriptor(electrocardiogram)
                for try await measurement in electrocardiogramQueryDescriptor.results(for: self.healthKitDataSource.healthStore) {
                    if let voltageQuantity = measurement.quantity(for: .appleWatchSimilarToLeadI) {
                        voltageMeasurements.append((measurement.timeSinceSampleStart, voltageQuantity))
                    }
                }
                
                return Electrocardiogram(
                    hkElectrocardiogram: electrocardiogram,
                    symptoms: symptoms,
                    voltageMeasurements: voltageMeasurements
                )
            }
            return nil
        })
    }()
    
    
    public func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]) {
        #warning("Remove after thesting")
        Task {
            await self.healthKitDataSource.beginDataDelivery()
            print(dataSource)
        }
    }
}

