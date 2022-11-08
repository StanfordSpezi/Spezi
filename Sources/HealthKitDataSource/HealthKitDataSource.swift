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


class HealthKitDataSource<ComponentStandard: Standard, SampleType: CorrelatingSampleType>: Component {
    @Dependency var healthKitHealthStoreComponent = HealthKitHealthStore()
    @Dependency var healthKitObserver = HealthKitObserver()
    private let sampleType: SampleType
    
    
    var healthStore: HKHealthStore {
        healthKitHealthStoreComponent.healthStore
    }
    
    
    init(sampleType: SampleType) {
        self.sampleType = sampleType
    }
    
    
    func loadData(
        withPredicate predicate: NSPredicate? = nil
    ) async throws -> [SampleType.Sample] {
        // Create the descriptor.
        let sampleQueryDescriptor = HKSampleQueryDescriptor(
            predicates: [
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
