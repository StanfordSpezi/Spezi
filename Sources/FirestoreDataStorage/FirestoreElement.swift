//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Provides a mapping from a FHIR `Resource` to a type conforming to `FirestoreElement`.
public struct FirestoreElement: Encodable, Identifiable, Sendable {
    /// <#Description#>
    public let id: String
    /// <#Description#>
    public var collectionPath: String
    let body: Encodable & Sendable
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - id: <#id description#>
    ///   - collectionPath: <#collectionPath description#>
    ///   - body: <#body description#>
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
