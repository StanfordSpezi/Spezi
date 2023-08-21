//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``ValueRepository`` that allows to store any ``KnowledgeSource``s.
public typealias UniversalValueRepository = ValueRepository<Any>


/// A ``SharedRepository`` implementation that itself is a value type.
///
/// - Note: The ``ValueRepository`` is considered `Sendable` if the ``RepositoryAnchor`` conforms to `Sendable`.
public struct ValueRepository<Anchor>: SharedRepository, BuiltinRepository {
    var storage: Container = [:]


    public init() {}


    public func get<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value? {
        get0(source)
    }

    public mutating func set<Source: KnowledgeSource<Anchor>>(_ source: Source.Type, value newValue: Source.Value?) {
        set0(source, value: newValue)
    }

    public func collect<Value>(allOf type: Value.Type) -> [Value] {
        collect0(allOf: type)
    }
}

extension ValueRepository: Collection {
    public typealias Index = Dictionary<ObjectIdentifier, AnyRepositoryValue>.Index

    public var startIndex: Index {
        storage.values.startIndex
    }

    public var endIndex: Index {
        storage.values.endIndex
    }

    public func index(after index: Index) -> Index {
        storage.values.index(after: index)
    }


    public subscript(position: Index) -> AnyRepositoryValue {
        storage.values[position]
    }
}


extension ValueRepository: @unchecked Sendable where Anchor: Sendable {}
