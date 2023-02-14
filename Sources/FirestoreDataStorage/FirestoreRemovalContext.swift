//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Provides a mapping from a FHIR standard `RemovalContext` to a type conforming to `FHIRFirestoreRemovalContext`.
public struct FirestoreRemovalContext: Identifiable, Sendable {
    /// The identifier that is used for the Firestore document.
    public let id: String
    /// The collection path that is used for the Firestore document.
    public var collectionPath: String
    
    
    /// - Parameters:
    ///   - id: The identifier that is used for the Firestore document.
    ///   - collectionPath: The collection path that is used for the Firestore document.
    public init(
        id: String,
        collectionPath: String
    ) {
        self.id = id
        self.collectionPath = collectionPath
    }
}
