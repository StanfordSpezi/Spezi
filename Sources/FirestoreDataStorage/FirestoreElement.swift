//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Provides a mapping from a FHIR `Resource` to a type conforming to `FirestoreElement`.
public struct FirestoreElement: Encodable, Identifiable, Sendable {
    /// The identifier that is used for the Firestore document.
    public let id: String
    /// The collection path that is used for the Firestore document.
    public var collectionPath: String
    let body: Encodable & Sendable
    
    
    /// - Parameters:
    ///   - id: The identifier that is used for the Firestore document.
    ///   - collectionPath: The collection path that is used for the Firestore document.
    ///   - body: The body of the document, including all fields as defined by the `Encodable` implementation.
    public init<Body: Encodable & Sendable>(
        id: String,
        collectionPath: String,
        _ body: Body
    ) {
        self.id = id
        self.collectionPath = collectionPath
        self.body = body
    }
    
    
    public func encode(to encoder: Encoder) throws {
        try body.encode(to: encoder)
    }
}
