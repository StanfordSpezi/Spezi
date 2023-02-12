//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


extension HKSample: Identifiable {
    public var id: UUID {
        uuid
    }
}


extension HKHealthStore {
    func anchoredSingleObjectQuery(
        for sampleType: HKSampleType,
        using anchor: HKQueryAnchor? = nil,
        withPredicate predicate: NSPredicate? = nil
    ) async throws -> (elements: [DataChange<HKSample, HKSampleRemovalContext>], anchor: HKQueryAnchor) {
        try await self.requestAuthorization(toShare: [], read: [sampleType])
        
        let anchorDescriptor = anchorDescriptor(sampleType: sampleType, predicate: predicate, anchor: anchor)
        
        let result = try await anchorDescriptor.result(for: self)
        
        var elements: [DataChange<HKSample, HKSampleRemovalContext>] = []
        elements.reserveCapacity(result.deletedObjects.count + result.addedSamples.count)
        
        for deletedObject in result.deletedObjects {
            elements.append(.removal(HKSampleRemovalContext(id: deletedObject.uuid, sampleType: sampleType)))
        }
        
        for addedSample in result.addedSamples {
            elements.append(.addition(addedSample))
        }
        
        return (elements, result.newAnchor)
    }
    
    
    func anchorDescriptor(
        sampleType: HKSampleType,
        predicate: NSPredicate?,
        anchor: HKQueryAnchor?
    ) -> HKAnchoredObjectQueryDescriptor<HKSample> {
        HKAnchoredObjectQueryDescriptor(
            predicates: [
                .sample(type: sampleType, predicate: predicate)
            ],
            anchor: anchor
        )
    }
}
