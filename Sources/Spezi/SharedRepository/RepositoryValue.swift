//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Represents type erased ``RepositoryValue``.
public protocol AnyRepositoryValue {
    /// This property gives access to a type-erased version of ``RepositoryValue/Source``
    var anySource: any KnowledgeSource.Type { get }
    /// This property gives access to a type-erased version of ``RepositoryValue/value``.
    var anyValue: Any { get }
}


/// A type that represents a stored value inside a ``SharedRepository``.
///
/// You may also think of it as a stored instance of a ``KnowledgeSource``.
public protocol RepositoryValue<Source>: AnyRepositoryValue {
    /// The ``KnowledgeSource`` for which the value is stored.
    associatedtype Source: KnowledgeSource


    /// The value instance of the ``KnowledgeSource``.
    var value: Source.Value { get }


    init(_ value: Source.Value)
}


extension RepositoryValue {
    /// The type erased ``RepositoryValue/Source``.
    public var anySource: any KnowledgeSource.Type {
        Source.self
    }

    /// The type erased ``RepositoryValue/value``.
    public var anyValue: Any {
        value
    }
}
