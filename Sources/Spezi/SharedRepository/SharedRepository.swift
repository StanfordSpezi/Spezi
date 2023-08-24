//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// This protocol provides a common interface for a storage mechanism that allows multiple entities
/// to access, provide and modify shared data.
///
/// A `SharedRepository` allows to easily integrate application functionality with a data-driven control flow or
/// applications that operate on the same data, but do not share the same processing workflow or are split across
/// multiple software systems (Buschmann et al. _Pattern-Oriented Software Architecture: A Pattern Language for Distributed Computing_).
///
/// This concrete `SharedRepository` implementation acts as a typed collection. The stored data is defined and
/// keyed by ``KnowledgeSource`` instances. All values in a `SharedRepository` share the same ``Anchor``.
public protocol SharedRepository<Anchor> {
    /// The associated ``RepositoryAnchor``.
    ///
    /// Use this Anchor to constraint the set of values to a certain set of ``KnowledgeSource`` namely all
    /// ``KnowledgeSource`` which are anchored to the same ``RepositoryAnchor``.
    ///
    /// - Note: This associated type doesn't enforce conformance to the ``RepositoryAnchor`` protocol to allow the
    ///     usage of `Any`. Using `Any` as an ``Anchor`` allows a repository to store an arbitrary set of ``KnowledgeSource``.
    associatedtype Anchor


    /// Retrieves a value from the shared repository.
    ///
    /// - Note: Do not use this method directly. Use the respective `subscript` implementations for a proper resolution
    ///     of different ``KnowledgeSource`` functionality.
    /// - Parameter source: The ``KnowledgeSource`` type for which we want to retrieve the value.
    /// - Returns: The stored ``KnowledgeSource/Value`` or `nil` if not present.
    func get<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value?

    /// Sets a value in the shared repository.
    ///
    /// - Note: Do not use this method directly. Use the respective `subscript` implementations for a proper resolution
    ///     of different ``KnowledgeSource`` functionality.
    /// - Parameters:
    ///   - source: The ``KnowledgeSource`` type for which we want to store the value.
    ///   - newValue: The ``KnowledgeSource/Value`` or nil to remove the value.
    mutating func set<Source: KnowledgeSource<Anchor>>(_ source: Source.Type, value newValue: Source.Value?)

    /// Collects all stored values that are of the provided type.
    /// - Parameter type: A type which we use to perform a `is` check on every stored value.
    /// - Returns: An array of values that are of the requested type.
    func collect<Value>(allOf type: Value.Type) -> [Value]

    /// Checks if the provided ``KnowledgeSource`` in currently stored in the shared repository.
    ///
    /// - Note: You should not rely on the ``contains(_:)-4lsie`` method for checking existence of ``ComputedKnowledgeSource``
    ///     ``OptionalComputedKnowledgeSource`` as these are entirely application defined.
    /// - Parameter source: The ``KnowledgeSource`` to check for.
    /// - Returns: Returns if the given ``KnowledgeSource`` is currently stored in the repository.
    func contains<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Bool


    /// A subscript to retrieve or set a ``KnowledgeSource``.
    /// - Parameter source: The ``KnowledgeSource`` type.
    /// - Returns: The stored ``KnowledgeSource/Value`` or `nil` if not present.
    subscript<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value? { get set }

    /// A subscript to retrieve or set a ``DefaultProvidingKnowledgeSource``.
    /// - Parameter source: The ``DefaultProvidingKnowledgeSource`` type.
    /// - Returns: The stored ``KnowledgeSource/Value`` or the ``DefaultProvidingKnowledgeSource/defaultValue``.
    subscript<Source: DefaultProvidingKnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value { get }

    /// A subscript to retrieve a ``ComputedKnowledgeSource``.
    ///
    /// - Note: This is the implementation for the ``SomeComputedKnowledgeSource/Store`` policy.
    ///     If the value was not present and got computed, the computed value will be stored in the repository.
    /// - Parameter source: The ``ComputedKnowledgeSource`` type.
    /// - Returns: The stored ``KnowledgeSource/Value`` or calls ``ComputedKnowledgeSource/compute(from:)`` to compute the value.
    subscript<Source: ComputedKnowledgeSource<Anchor>>(_ source: Source.Type)
        -> Source.Value where Source.StoragePolicy == _StoreComputePolicy { mutating get }

    /// A subscript to retrieve a ``ComputedKnowledgeSource``.
    ///
    /// - Note: This is the implementation for the ``SomeComputedKnowledgeSource/AlwaysCompute`` policy.
    ///     The ``ComputedKnowledgeSource/compute(from:)`` method will always be called as a result of this subscript call.
    /// - Parameter source: The ``ComputedKnowledgeSource`` type.
    /// - Returns: The calls ``ComputedKnowledgeSource/compute(from:)`` to compute the value.
    subscript<Source: ComputedKnowledgeSource<Anchor>>(_ source: Source.Type)
        -> Source.Value where Source.StoragePolicy == _AlwaysComputePolicy { get }

    /// A subscript to retrieve a ``OptionalComputedKnowledgeSource``.
    ///
    /// - Note: This is the implementation for the ``SomeComputedKnowledgeSource/Store`` policy.
    ///     If the value was not present and got computed, the computed value will be stored in the repository.
    /// - Parameter source: The ``OptionalComputedKnowledgeSource`` type.
    /// - Returns: The stored ``KnowledgeSource/Value`` or calls ``OptionalComputedKnowledgeSource/compute(from:)`` to compute the value
    ///     or `nil` if the `compute` method returned nil.
    subscript<Source: OptionalComputedKnowledgeSource<Anchor>>(_ source: Source.Type)
        -> Source.Value? where Source.StoragePolicy == _StoreComputePolicy { mutating get }

    /// A subscript to retrieve a ``OptionalComputedKnowledgeSource``.
    ///
    /// - Note: This is the implementation for the ``SomeComputedKnowledgeSource/AlwaysCompute`` policy.
    ///     The ``OptionalComputedKnowledgeSource/compute(from:)`` method will always be called as a result of this subscript call.
    /// - Parameter source: The ``OptionalComputedKnowledgeSource`` type.
    /// - Returns: The calls ``OptionalComputedKnowledgeSource/compute(from:)`` to compute the value
    ///     or `nil` if the `compute` method returned nil.
    subscript<Source: OptionalComputedKnowledgeSource<Anchor>>(_ source: Source.Type)
        -> Source.Value? where Source.StoragePolicy == _AlwaysComputePolicy { get }
}

extension SharedRepository {
    /// Default contains method calling ``get(_:)``.
    public func contains<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Bool {
        self.get(source) != nil
    }


    /// Default subscript implementation delegating to ``get(_:)`` or ``set(_:value:)``.
    public subscript<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value? {
        get {
            get(source)
        }
        set {
            set(source, value: newValue)
        }
    }

    /// Default subscript implementation delegating to ``get(_:)`` or providing a ``DefaultProvidingKnowledgeSource/defaultValue``.
    public subscript<Source: DefaultProvidingKnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value {
        self.get(source) ?? source.defaultValue
    }

    /// Default subscript implementation delegating to ``get(_:)`` or calling ``ComputedKnowledgeSource/compute(from:)``
    /// and storing the result.
    public subscript<Source: ComputedKnowledgeSource<Anchor>>(_ source: Source.Type)
        -> Source.Value where Source.StoragePolicy == _StoreComputePolicy {
        mutating get {
            if let value = self.get(source) {
                return value
            }

            let value = source.compute(from: self)
            self[source] = value
            return value
        }
    }

    /// Default subscript implementation delegating calling ``ComputedKnowledgeSource/compute(from:)``.
    public subscript<Source: ComputedKnowledgeSource<Anchor>>(_ source: Source.Type)
        -> Source.Value where Source.StoragePolicy == _AlwaysComputePolicy {
        source.compute(from: self)
    }

    /// Default subscript implementation delegating to ``get(_:)`` or calling ``OptionalComputedKnowledgeSource/compute(from:)``
    /// and storing the result.
    public subscript<Source: OptionalComputedKnowledgeSource<Anchor>>(_ source: Source.Type)
        -> Source.Value? where Source.StoragePolicy == _StoreComputePolicy {
        mutating get {
            if let value = self.get(source) {
                return value
            }

            let value = source.compute(from: self)
            self[source] = value
            return value
        }
    }

    /// Default subscript implementation delegating calling ``OptionalComputedKnowledgeSource/compute(from:)``.
    public subscript<Source: OptionalComputedKnowledgeSource<Anchor>>(_ source: Source.Type)
        -> Source.Value? where Source.StoragePolicy == _AlwaysComputePolicy {
        source.compute(from: self)
    }
}
