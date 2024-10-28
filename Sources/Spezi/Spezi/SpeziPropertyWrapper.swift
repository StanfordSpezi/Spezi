//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


enum SpeziPropertyError: Error {
    case unsatisfiedStandardConstraint(constraint: String, standard: String)
}


protocol SpeziPropertyWrapper {
    /// Inject the global Spezi instance.
    ///
    /// This call happens right before ``Module/configure()-5pa83`` is called.
    /// An empty default implementation is provided.
    /// - Parameter spezi: The global ``Spezi/Spezi`` instance.
    @MainActor
    func inject(spezi: Spezi) throws(SpeziPropertyError)

    /// Clear the property wrapper state before the Module is unloaded.
    @MainActor
    func clear()
}


extension SpeziPropertyWrapper {
    func inject(spezi: Spezi) {}
}


extension Module {
    @MainActor
    func inject(spezi: Spezi) throws(SpeziPropertyError) {
        for wrapper in retrieveProperties(ofType: SpeziPropertyWrapper.self) {
            try wrapper.inject(spezi: spezi)
        }
    }

    @MainActor
    func clear() {
        for wrapper in retrieveProperties(ofType: SpeziPropertyWrapper.self) {
            wrapper.clear()
        }
    }
}


extension SpeziPropertyError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .unsatisfiedStandardConstraint(constraint, standard):
                """
                The `Standard` defined in the `Configuration` does not conform to \(constraint).
                
                Ensure that you define an appropriate standard in your configuration in your `SpeziAppDelegate` subclass ...
                ```
                var configuration: Configuration {
                    Configuration(standard: \(standard)()) {
                        // ...
                    }
                }
                ```
                
                ... and that your standard conforms to \(constraint):
                
                ```swift
                actor \(standard): Standard, \(constraint) {
                    // ...
                }
                ```
                """
        }
    }
}
