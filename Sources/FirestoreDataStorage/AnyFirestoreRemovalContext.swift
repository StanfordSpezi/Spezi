//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Provides the nescessary removal context for the ``Firestore`` date storage component.
public protocol AnyFirestoreRemovalContext: Identifiable, Sendable where ID == String {
    /// The collection path where the ``FirestoreElement`` is located at.
    var collectionPath: String { get }
}
