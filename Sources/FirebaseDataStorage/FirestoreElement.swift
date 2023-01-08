//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


public protocol FirestoreElement: Encodable, Identifiable, Sendable where ID == String {
    var collectionPath: String { get }
}

public protocol FirestoreRemovalContext: Identifiable, Sendable where ID == String {
    var collectionPath: String { get }
}
