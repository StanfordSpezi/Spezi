//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A Storage Policy defines for Computed ``KnowledgeSource``s how the result of the `compute` function is handled.
///
/// The following implementations exist:
/// * ``SomeComputedKnowledgeSource/AlwaysCompute``: Always call the compute method.
/// * ``SomeComputedKnowledgeSource/Store``: Store the result of the compute and return the cached result in subsequent calls.
public protocol ComputedKnowledgeSourceStoragePolicy {}


public struct _AlwaysComputePolicy: ComputedKnowledgeSourceStoragePolicy {
    // swiftlint:disable:previous type_name
}


public struct _StoreComputePolicy: ComputedKnowledgeSourceStoragePolicy {
    // swiftlint:disable:previous type_name
}


/// The `SomeComputedKnowledgeSource` provides common abstractions for any of the available Computed ``KnowledgeSource``s.
///
/// The following implementations exist:
/// * ``ComputedKnowledgeSource``
/// * ``OptionalComputedKnowledgeSource``
public protocol SomeComputedKnowledgeSource<Anchor>: KnowledgeSource {
    /// Defines the Storage Policy for the Computed Knowledge Source.
    ///
    /// For more information see ``ComputedKnowledgeSourceStoragePolicy``.
    /// By default we use the ``SomeComputedKnowledgeSource/Store`` policy.
    associatedtype StoragePolicy: ComputedKnowledgeSourceStoragePolicy = Store
}


extension SomeComputedKnowledgeSource {
    /// A Storage Policy that ensures that the `compute` method is always getting called.
    public typealias AlwaysCompute = _AlwaysComputePolicy
    /// A Storage Policy that stores and caches results of the `compute` method.
    public typealias Store = _StoreComputePolicy
}
