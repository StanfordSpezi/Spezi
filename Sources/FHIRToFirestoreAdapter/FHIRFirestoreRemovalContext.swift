//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FHIR
import FirestoreDataStorage
import Foundation


/// Provides a mapping from a FHIR standard `RemovalContext` to a type conforming to `FHIRFirestoreRemovalContext`.
public struct FHIRFirestoreRemovalContext: FirestoreRemovalContext, @unchecked Sendable {
    public let id: String
    public let collectionPath: String
    
    
    init(_ removalContext: FHIR.RemovalContext) {
        self.id = removalContext.id?.value?.string ?? UUID().uuidString
        self.collectionPath = removalContext.resourceType.rawValue
    }
}
