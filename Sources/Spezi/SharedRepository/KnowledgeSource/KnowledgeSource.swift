//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A `KnowledgeSource` serves as a typed key for a ``SharedRepository`` implementation.
///
/// A ``KnowledgeSource`` is anchored to a given ``RepositoryAnchor`` and defines a ``Value`` type which by default
/// is set to `Self`.
public protocol KnowledgeSource<Anchor> {
    /// The type of a value this `KnowledgeSource` represents.
    associatedtype Value = Self
    /// The ``RepositoryAnchor`` to which this `KnowledgeSource` is anchored to.
    associatedtype Anchor: RepositoryAnchor


    /// Optional reduction algorithm to handle overriding existing entries.
    ///
    /// The default implementation overrides the existing value.
    /// - Parameters:
    ///   - value: The existing value to reduce into.
    ///   - nextValue: The next value.
    static func reduce(value: inout Self.Value, nextValue: Self.Value)
}

extension KnowledgeSource {
    /// The default implementation override the current value.
    /// - Parameters:
    ///   - value: The existing value to reduce into.
    ///   - nextValue: The next value.
    public static func reduce(value: inout Self.Value, nextValue: Self.Value) {
        value = nextValue
    }
}
