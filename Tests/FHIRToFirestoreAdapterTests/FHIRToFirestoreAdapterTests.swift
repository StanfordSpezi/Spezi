//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIR
import FHIRToFirestoreAdapter
import ModelsR4
import XCTest


final class FHIRToFirestoreAdapterTests: XCTestCase {
    func testHealthKitToFHIRAdapterTransformElement() async throws {
        let adapter = FHIRToFirestoreAdapter()
        
        let observation = Observation(
            code: CodeableConcept(),
            id: "1",
            status: FHIRPrimitive<ObservationStatus>(.final)
        )
        
        let mappedElement = try await adapter.transform(element: observation)
        
        XCTAssert(mappedElement.id == "1")
        XCTAssert(mappedElement.collectionPath == "Observation")
    }
    
    func testHealthKitToFHIRAdapterTransformReuseContext() async throws {
        let adapter = FHIRToFirestoreAdapter()
        
        let removalContext = FHIR.RemovalContext(id: "1", resourceType: .observation)
        
        let mappedRemovalContext = try await adapter.transform(removalContext: removalContext)
        
        XCTAssert(mappedRemovalContext.id == "1")
        XCTAssert(mappedRemovalContext.collectionPath == "Observation")
    }
}
