//
// Created by Andreas Bauer on 15.07.23.
//

import Foundation

public protocol KnowledgeSource<Anchor> { // TODO what is primary here?
    associatedtype Value: Sendable = Self // TODO sendable requirement?
    associatedtype Anchor: SharedRepositoryAnchor
    // knowledge source can either be provided by manually setting them or by initializing it from the environment/shared repository!

    // TODO abstract over an implementation type?
    // TODO key based Knowledge sources?
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
    static func compute<Repository: SharedRepository<Anchor>>(from repository: Repository) throws -> Value?
}
