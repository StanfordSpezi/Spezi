//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import OrderedCollections
import SpeziFoundation


protocol AnyStoredModules {
    var anyModules: [any Module] { get }

    func removeNilReferences<Repository: SharedRepository<SpeziAnchor>>(in storage: inout Repository)
}


struct StoredModulesKey<M: Module>: KnowledgeSource {
    typealias Anchor = SpeziAnchor
    typealias Value = Self

    var modules: OrderedDictionary<ModuleReference, DynamicReference<M>>

    var isEmpty: Bool {
        modules.isEmpty
    }

    init(_ module: DynamicReference<M>, forKey key: ModuleReference) {
        modules = [key: module]
    }

    func contains(_ key: ModuleReference) -> Bool {
        modules[key] != nil
    }

    func retrieveFirstAvailable() -> M? {
        for (_, value) in modules {
            guard let element = value.element else {
                continue
            }
            return element
        }
        return nil
    }

    @discardableResult
    mutating func updateValue(_ module: DynamicReference<M>, forKey key: ModuleReference) -> DynamicReference<M>? {
        modules.updateValue(module, forKey: key)
    }

    @discardableResult
    mutating func removeValue(forKey key: ModuleReference) -> DynamicReference<M>? {
        modules.removeValue(forKey: key)
    }
}


extension StoredModulesKey: AnyStoredModules {
    var anyModules: [any Module] {
        modules.reduce(into: []) { partialResult, entry in
            guard let element = entry.value.element else {
                return
            }
            partialResult.append(element)
        }
    }

    func removeNilReferences<Repository: SharedRepository<SpeziAnchor>>(in storage: inout Repository) {
        guard modules.contains(where: { $0.value.element == nil }) else {
            return // no weak references
        }

        var value = self

        value.modules.removeAll { _, value in
            value.element == nil
        }

        storage[Self.self] = value
    }
}
