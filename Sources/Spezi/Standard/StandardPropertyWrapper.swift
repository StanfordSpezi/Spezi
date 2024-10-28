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
public class _StandardPropertyWrapper<Constraint> {
    // swiftlint:disable:previous type_name
    // We want the _StandardPropertyWrapper type to be hidden from autocompletion and document generation.
    
    private var standard: Constraint?
    
    
    /// The injected ``Standard`` that is resolved by ``Spezi/Spezi``.
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
    public init(_ constraint: Constraint.Type = Constraint.self) {}
}


extension _StandardPropertyWrapper: SpeziPropertyWrapper {
    func inject(spezi: Spezi) throws(SpeziPropertyError) {
        guard let standard = spezi.standard as? Constraint else {
            let standardType = type(of: spezi.standard)
            throw SpeziPropertyError.unsatisfiedStandardConstraint(
                constraint: String(describing: Constraint.self),
                standard: String(describing: standardType)
            )
        }

        self.standard = standard
    }

    func clear() {
        standard = nil
    }
}
