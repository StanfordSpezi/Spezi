//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``ModuleCollection`` defines a collection of ``Module``s .
///
/// You can not create a ``ModuleCollection`` yourself. Please use the ``ModuleBuilder`` to create a ``ModuleCollection``.
public class ModuleCollection {
    let elements: [any Module]
    
    
    init(elements: [any Module]) {
        self.elements = elements
    }
}
