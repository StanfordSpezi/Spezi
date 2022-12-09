//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``ComponentCollection`` defines a collection of ``Component``s that can utilize the `ComponentsStandard`.
///
/// You can not create a ``ComponentCollection`` yourself. Please use the ``ComponentBuilder`` to create a ``ComponentCollection``.
public class ComponentCollection<ComponentsStandard: Standard> {
    let elements: [any Component<ComponentsStandard>]
    
    
    init(elements: [any Component<ComponentsStandard>]) {
        self.elements = elements
    }
}
