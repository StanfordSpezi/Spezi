//
// This source file is part of the Stanford Spezi open-source project
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
    func saveInTypedCollection(spezi: AnySpezi) {
        guard let value = self as? Value else {
            return
        }
        
        spezi.typedCollection.set(Self.self, to: value)
    }
}
