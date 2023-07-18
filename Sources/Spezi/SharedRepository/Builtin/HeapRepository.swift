//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


public typealias UniversalHeapSharedRepository<Value: RepositoryValue> = HeapRepository<Any>

// TODO provide ValueRepository (and SendableValueRepository!)
public final class HeapRepository<Anchor>: SharedRepository, BuiltinRepository {
    public typealias Container = [ObjectIdentifier: AnyRepositoryValue]

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
