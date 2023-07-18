//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation

public protocol KnowledgeSource<Anchor> {
    associatedtype Value = Self
    associatedtype Anchor: RepositoryAnchor

    static func reduce(value: inout Self.Value, nextValue: Self.Value)
}

extension KnowledgeSource {
    // TODO use reduce function in implementations!
    public static func reduce(value: inout Self.Value, nextValue: Self.Value) {
        value = nextValue
    }
}

public protocol DefaultProvidingKnowledgeSource<Anchor>: KnowledgeSource {
    // a default value should have value semantics
    static var defaultValue: Value { get } // TODO empty defaults for Bool, Array, Dicitonary?
}

public protocol ComputedKnowledgeSource<Anchor>: KnowledgeSource {
    // TODO provide default errors!
    static func compute<Repository: SharedRepository<Anchor>>(from repository: Repository) throws -> Value
}

public protocol OptionalComputedKnowledgeSource<Anchor>: KnowledgeSource {
    // TODO determinisitc requirment!
    static func compute<Repository: SharedRepository<Anchor>>(from repository: Repository) throws -> Value?
}
