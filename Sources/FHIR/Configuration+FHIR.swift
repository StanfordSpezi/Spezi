//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit


extension Configuration {
    /// A  FHIR-based ``Configuration``that  defines ``Component``s that are used in a CardinalKit project.
    ///
    /// See ``Configuration`` for more detail about standard-independent configurations.
    /// - Parameters:
    ///   - components: The ``Component``s used in the CardinalKit project. You can define the ``Component``s using the ``ComponentBuilder`` result builder.
    public init(
        @ComponentBuilder<FHIR> _ components: () -> (ComponentCollection<FHIR>)
    ) {
        self.init(
            standard: FHIR(),
            components
        )
    }
}
