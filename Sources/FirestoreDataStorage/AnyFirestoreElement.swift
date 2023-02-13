//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Provides the nescessary information context for the ``Firestore`` date storage component to store a new element or update an existing element.
public protocol AnyFirestoreElement: Encodable, Identifiable, Sendable where ID == String {
    /// The collection path where the ``FirestoreElement`` should be stored at.
    var collectionPath: String { get }
}
