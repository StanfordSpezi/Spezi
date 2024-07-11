//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


struct DependencyReference: Hashable, Sendable {
    let reference: ModuleReference
    private let typeId: ObjectIdentifier

    init<M: Module>(_ module: M) {
        self.reference = ModuleReference(module)
        self.typeId = ObjectIdentifier(M.self)
    }

    func sameType<M: Module>(as module: M.Type) -> Bool {
        typeId == ObjectIdentifier(M.self)
    }
}


extension Module {
    var dependencyReference: DependencyReference {
        DependencyReference(self)
    }
}
