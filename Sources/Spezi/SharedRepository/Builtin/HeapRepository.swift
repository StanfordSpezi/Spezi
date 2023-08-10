//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``HeapRepository`` that allows to store any ``KnowledgeSource``s.
public typealias UniversalHeapRepository = HeapRepository<Any>


/// A ``SharedRepository`` implementation that itself is a reference type.
public final class HeapRepository<Anchor>: SharedRepository, BuiltinRepository {
    var storage: Container = [:]


    public init() {}


    public func get<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value? {
        get0(source)
    }

    public func set<Source: KnowledgeSource<Anchor>>(_ source: Source.Type, value newValue: Source.Value?) {
        var this = self
        this.set0(source, value: newValue)
    }

    public func collect<Value>(allOf type: Value.Type) -> [Value] {
        collect0(allOf: type)
    }
}


extension HeapRepository: Collection {
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
