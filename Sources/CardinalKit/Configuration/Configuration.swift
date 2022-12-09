//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


///// A ``Configuration`` defines the ``Standard`` and ``Component``s that are used in a CardinalKit project.
public struct Configuration {
    let cardinalKit: AnyCardinalKit
    

    /// A ``Configuration`` defines the ``Standard`` and ``Component``s that are used in a CardinalKit project.
    /// - Parameters:
    ///   - standard: The ``Standard`` that is used in the CardinalKit project.
    ///   - components: The ``Component``s used in the CardinalKit project. You can define the ``Component``s using the ``ComponentBuilder`` result builder.
    public init<S: Standard>(
        standard: S,
        @ComponentBuilder<S> _ components: () -> (ComponentCollection<S>)
    ) {
        self.cardinalKit = CardinalKit<S>(standard: standard, components: components().elements)
    }
}
