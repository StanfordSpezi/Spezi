//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Key used to identify stored elements in `TypedCollection` instances.
public protocol TypedCollectionKey<Value> {
    /// The value type associated with the `TypedCollectionKey`.
    associatedtype Value = Self
}

extension TypedCollectionKey {
    func saveInTypedCollection(cardinalKit: AnyCardinalKit) {
        guard let value = self as? Value else {
            return
        }
        
        cardinalKit.typedCollection.set(Self.self, to: value)
    }
}
