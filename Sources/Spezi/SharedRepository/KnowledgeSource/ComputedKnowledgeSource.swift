//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``KnowledgeSource`` that allows to compose it's values from it's surrounding knowledge environment.
public protocol ComputedKnowledgeSource<Anchor>: SomeComputedKnowledgeSource {
    /// Computes the value of the ``KnowledgeSource``.
    ///
    /// - Note: The implementation of this method must be deterministic.
    /// - Parameter repository: The repository to use for computation.
    /// - Returns: Returns the computed value.
    static func compute<Repository: SharedRepository<Anchor>>(from repository: Repository) -> Value
}
