//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A internal helper protocol to reduce code duplication of built in ``SharedRepository`` implementations.
protocol BuiltinRepository {
    associatedtype Anchor
    typealias Container = [ObjectIdentifier: AnyRepositoryValue]

    var storage: Container { get set }
}


// extension provide default implementation with `0` suffix, as these all have internal visibility.
extension BuiltinRepository {
    func get0<Source: KnowledgeSource<Anchor>>(_ source: Source.Type) -> Source.Value? {
        guard let value = storage[ObjectIdentifier(source)] as? SimpleRepositoryValue<Source> else {
            return nil
        }

        return value.value
    }

    mutating func set0<Source: KnowledgeSource<Anchor>>(_ source: Source.Type, value newValue: Source.Value?) {
        let key = ObjectIdentifier(source)

        guard let newValue else {
            self.storage[key] = nil
            return
        }

        if var existing = get0(source) {
            Source.reduce(value: &existing, nextValue: newValue)
            self.storage[key] = SimpleRepositoryValue<Source>(existing)
        } else {
            self.storage[key] = SimpleRepositoryValue<Source>(newValue)
        }
    }

    func collect0<Value>(allOf type: Value.Type) -> [Value] {
        storage.values.compactMap { value in
            value.anyValue as? Value
        }
    }
}
