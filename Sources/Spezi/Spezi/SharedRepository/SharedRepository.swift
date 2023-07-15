//
// Created by Andreas Bauer on 15.07.23.
//

import Foundation

// TODO SharedRepository (https://opac.ub.tum.de/TouchPoint/perma.do?q=+0%3D%22ZDB-30-ORH-047475692%22+IN+%5B2%5D&v=tum&l=de)
//   => DomainObjects (value object, copied value, immutable value) /Managed objects? (to capture data?) => "hide details of concrete data structures and offer meaninful operations for their access and modification"
//   => no notification options for new/modified data (Observer pattern?) (repository vs managed objects granularity)
//  Property Wrappers:
//   - @Provide
//   - @Request // @Require
//  Component "setup cycles":
//   - register/preprocess (ordered?) => main goal to init shared repository => last chance to write to @Provide!
//   - configure (ordered; SharedRepository initialized)!


// TODO we need a generalized SharedRepository pattern here
//  - stores e.g. the primary account service
//  - stores account service configuration elements (by just pulling them out of the account service
//  - allows for computed account values (e.g., email address source from userId if present, otherwise it may be an optional stored thing?)
//  - It replaces the TypedCollection.swift for `Spezi`
//  - allows for distinct instantiations! (e.g. AccountValue system is different from the Spezi typed storage and different between the shared component storage!)

// TODO you might just use Any?
public protocol SharedRepositoryAnchor {} // TODO should we provide a default?

extension KnowledgeSource {
    // TODO document because of the downcast
    fileprivate static func retrieve<Repository: SharedRepository<Anchor>>(from repository: Repository) -> Value? {
        repository[Self.self]
    }
}

// TODO create SendableSharedRepository!
public protocol SharedRepository<Anchor> { // TODO should all repos be sendable?
    associatedtype Anchor // TODO does not conform to Anchor, such that you can use `Any`

    // TODO nonmutating set makes it impossible to restrict writes using struct based repository
    subscript<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value? { get nonmutating set }

    subscript<Source: DefaultProvidingKnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value { get }

    // TODO document request to access error
    subscript<Source: ComputedKnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value { mutating get throws } // TODO not all might throw?
    // TODO document request to access error
    subscript<Source: OptionalComputedKnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value? { mutating get throws }

    // TODO contains or computed (is hard to measure for computed knowledge sources? make a note on computed sources)
    func contains<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Bool

    func collect<Value>(allOf type: Value.Type) -> [Value]
}

extension SharedRepository {
    public subscript<Source: DefaultProvidingKnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value {
        source.retrieve(from: self) ?? source.defaultValue
    }

    public subscript<Source: ComputedKnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value {
        mutating get throws {
            if let value = source.retrieve(from: self) {
                return value
            }

            let value = try source.compute(from: self)
            self[source] = value
            return value
        }
    }

    public subscript<Source: OptionalComputedKnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value? {
        mutating get throws {
            // TODO we could reuse the above?
            if let value = source.retrieve(from: self) {
                return value
            }

            guard let value = try source.compute(from: self) else {
                return nil
            }
            self[source] = value
            return value
        }
    }

    public func contains<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Bool {
        source.retrieve(from: self) != nil
    }
}

public protocol MutableSharedRepository: SharedRepository {
    subscript<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Source? { get set } // TODO mutating set?

    // TODO all the other setters?
}

public protocol AnySharedRepositoryValue {
    var anyValue: Any { get } // TODO required?
}

public protocol SharedRepositoryValue<Source>: AnySharedRepositoryValue {
    associatedtype Source: KnowledgeSource

    var value: Source.Value { get }

    init(_ value: Source.Value)

    // TODO support removal handlers?
}

extension SharedRepositoryValue {
    public var anyValue: Any {
        value
    }
}

public typealias AnyDefaultSharedRepository<Value: SharedRepositoryValue> = DefaultSharedRepository<Any>

// TODO we may just not provide a default implementation?
// TODO heap based storage?
// TODO rename to `HeapRepository`/`HeapSharedRepository`?
public final class DefaultSharedRepository<Anchor>: SharedRepository {
    public struct Value<Source: KnowledgeSource>: SharedRepositoryValue where Source.Anchor == Anchor {
        public let value: Source.Value

        public init(_ value: Source.Value) {
            self.value = value
        }
    }

    // TODO have a default StorageItem implementation! => still an issue!
    private var storage: [ObjectIdentifier: AnySharedRepositoryValue] = [:]

    public init() {}

    public subscript<Source: KnowledgeSource<Anchor>>(source: Source.Type) -> Source.Value? {
        get {
            guard let value = storage[ObjectIdentifier(source)] as? Value<Source> else {
                return nil
            }

            return value.value
        }
        set {
            let key = ObjectIdentifier(source)

            if let value = newValue {
                self.storage[key] = Value<Source>(value)
            } else {
                self.storage[key] = nil
            }
        }
    }

    public func collect<Value>(allOf type: Value.Type) -> [Value] {
        storage.values.compactMap { value in
            value.anyValue as? Value
        }
    }
}
