//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTRuntimeAssertions


/// Refer to ``Module/StandardActor`` for information on how to use the `@StandardActor` property wrapper. Do not use the `_StandardPropertyWrapper` directly.
@propertyWrapper
public class _StandardPropertyWrapper<Constraint>: AnyStandardPropertyWrapper {
    // swiftlint:disable:previous type_name
    // We want the _StandardPropertyWrapper type to be hidden from autocompletion and document generation.
    
    private var standard: Constraint?
    
    
    /// The injected ``Standard`` that is resolved by ``Spezi``
    public var wrappedValue: Constraint {
        guard let standard else {
            preconditionFailure(
                """
                A `_StandardPropertyWrapper`'s wrappedValue was accessed before the `Module` was configured.
                Only access dependencies once the module has been configured and the Spezi initialization is complete.
                """
            )
        }
        return standard
    }
    
    
    /// Refer to ``Module/StandardActor`` for information on how to use the `@StandardActor` property wrapper. Do not use the `_StandardPropertyWrapper` directly.
    public init(_ constraint: Constraint.Type = Constraint.self) { }
    
    
    func inject<S: Standard>(standard: S) {
        guard let standard = standard as? Constraint else {
            preconditionFailure(
                """
                The `Standard` defined in the `Configuration` does not conform to \(String(describing: Constraint.self)).
                
                Ensure that you define an appropriate standard in your configuration in your `SpeziAppDelegate` subclass ...
                ```
                var configuration: Configuration {
                    Configuration(standard: \(String(describing: S.self))()) {
                        // ...
                    }
                }
                ```
                
                ... and that your standard conforms to \(String(describing: Constraint.self)):
                
                ```swift
                actor \(String(describing: S.self)): Standard, \(String(describing: Constraint.self)) {
                    // ...
                }
                ```
                """
            )
        }
        
        self.standard = standard
    }
}
