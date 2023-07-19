//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``KnowledgeSource`` that provides a default value.
public protocol DefaultProvidingKnowledgeSource<Anchor>: KnowledgeSource {
    /// The provided default value.
    ///
    /// A default value must stay consistent and must not change.
    static var defaultValue: Value { get }
}


/// A ``KnowledgeSource`` that allows to compose it's values from it's surrounding knowledge environment.
public protocol ComputedKnowledgeSource<Anchor>: KnowledgeSource {
    /// Computes the value of the ``KnowledgeSource``.
    ///
    /// - Note: The implementation of this method must be deterministic.
    /// - Parameter repository: The repository to use for computation.
    /// - Returns: Returns the computed value.
    static func compute<Repository: SharedRepository<Anchor>>(from repository: Repository) -> Value
}


/// A ``KnowledgeSource`` that allows to compose it's values from it's surrounding knowledge environment
/// but may deliver a optional value.
public protocol OptionalComputedKnowledgeSource<Anchor>: KnowledgeSource {
    /// Computes the value of the ``KnowledgeSource``.
    ///
    /// - Note: The implementation of this method must be deterministic.
    /// - Parameter repository: The repository to use for computation.
    /// - Returns: Returns the computed value or nil if nothing could be computed.
    static func compute<Repository: SharedRepository<Anchor>>(from repository: Repository) -> Value?
}


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
