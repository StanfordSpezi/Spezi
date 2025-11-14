//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Module {
    func retrieveProperties<Value>(ofType type: Value.Type) -> [Value] {
        let mirror = Mirror(reflecting: self)

        return mirror.children.compactMap { _, value in
            value as? Value
        }
    }
}
