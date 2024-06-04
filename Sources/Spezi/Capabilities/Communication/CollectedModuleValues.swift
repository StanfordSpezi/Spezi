//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation

protocol AnyCollectModuleValue {
    associatedtype Value

    var moduleReference: ModuleReference { get }
}

protocol AnyCollectModuleValues {
    associatedtype Value

    var values: [any AnyCollectModuleValue] { get }

    mutating func removeValues(from module: any Module) -> Bool

    func store(into storage: inout SpeziStorage)
}


struct CollectModuleValue<Value>: AnyCollectModuleValue {
    let value: Value
    let moduleReference: ModuleReference

    init(_ value: Value) {
        self.value = value

        guard let module = Spezi.moduleInitContext else {
            preconditionFailure("Tried to initialize CollectModuleValue with unknown module init context.")
        }
        self.moduleReference = ModuleReference(module)
    }
}

/// Provides the ``KnowledgeSource`` for any value we store in the ``SpeziStorage`` that is
/// provided or request from am ``Module``.
///
/// For more information, look at the ``Module/Provide`` or ``Module/Collect`` property wrappers.
struct CollectedModuleValues<ModuleValue>: DefaultProvidingKnowledgeSource {
    typealias Anchor = SpeziAnchor

    typealias Value = [CollectModuleValue<ModuleValue>]


    static var defaultValue: Value {
        []
    }
}


extension Array: AnyCollectModuleValues where Element: AnyCollectModuleValue {
    typealias Value = Element.Value

    var values: [any AnyCollectModuleValue] {
        self
    }

    mutating func removeValues(from module: any Module) -> Bool {
        let previousCount = count
        removeAll { entry in
            entry.moduleReference == ModuleReference(module)
        }
        return previousCount != count
    }

    func store(into storage: inout SpeziStorage) {
        guard let values = self as? [CollectModuleValue<Value>] else {
            preconditionFailure("Unexpected array type: \(type(of: self))")
        }
        storage[CollectedModuleValues<Value>.self] = values
    }
}
