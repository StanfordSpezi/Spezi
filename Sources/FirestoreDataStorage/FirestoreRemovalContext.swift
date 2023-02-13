//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Provides a mapping from a FHIR standard `RemovalContext` to a type conforming to `FHIRFirestoreRemovalContext`.
public struct FirestoreRemovalContext: Identifiable, Sendable {
    /// <#Description#>
    public let id: String
    /// <#Description#>
    public var collectionPath: String
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - id: <#id description#>
    ///   - collectionPath: <#collectionPath description#>
    public init(
        id: String,
        collectionPath: String
    ) {
        self.id = id
        self.collectionPath = collectionPath
    }
}
