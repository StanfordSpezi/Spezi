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


/// Provides a mapping from a FHIR `Resource` to a type conforming to `FirestoreElement`.
public struct FHIRFirestoreElement: FirestoreElement, @unchecked Sendable {
    let resource: Resource
    
    public let id: String
    public let collectionPath: String
    
    
    init(_ baseType: FHIR.BaseType) {
        self.resource = baseType
        self.id = baseType.id?.value?.string ?? UUID().uuidString
        self.collectionPath = ResourceProxy(with: baseType).resourceType
    }
    
    
    public func encode(to encoder: Encoder) throws {
        try resource.encode(to: encoder)
    }
}
