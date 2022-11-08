//
//  File.swift
//  
//
//  Created by Paul Shmiedmayer on 11/7/22.
//

import CardinalKit
import HealthKit


extension HKHealthStore {
    func sampleQuery(
        for sampleType: HKSampleType,
        withPredicate predicate: NSPredicate? = nil
    ) async throws -> [HKSample] {
        // Create the descriptor.
        let sampleQueryDescriptor = HKSampleQueryDescriptor(
            predicates: [
                .sample(type: sampleType, predicate: predicate)
            ],
            sortDescriptors: [
                SortDescriptor(\.endDate, order: .reverse)
            ]
        )
        
        return try await sampleQueryDescriptor.result(for: self)
    }
    
    
    func sampleQueryStream(
        for sampleType: HKSampleType,
        withPredicate predicate: NSPredicate? = nil
    ) -> AsyncThrowingStream<DataSourceElement<HKSample>, Error> {
        AsyncThrowingStream { continuation in
            Task {
                for sample in try await sampleQuery(for: sampleType, withPredicate: predicate) {
                    continuation.yield(.addition(sample))
                }
                continuation.finish()
            }
        }
    }
}
