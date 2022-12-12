//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTRuntimeAssertions


/// Refer to ``Component/StandardActor`` for information on how to use the `@StandardActor` property wrapper. Do not use the `_StandardPropertyWrapper` directly.
@propertyWrapper
public class _StandardPropertyWrapper<S: Standard> {
    // swiftlint:disable:previous type_name
    // We want the _StandardPropertyWrapper type to be hidden from autocompletion and document generation.
    
    private var standard: S?
    
    
    /// The injected ``Standard`` that is resolved by ``CardinalKit``
    public var wrappedValue: S {
        guard let standard else {
            preconditionFailure(
                """
                A `_StandardPropertyWrapper`'s wrappedValue was accessed before the `Component` was configured.
                Only access dependencies once the component has been configured and the CardinalKit initialization is complete.
                """
            )
        }
        return standard
    }
    
    
    /// Refer to ``Component/StandardActor`` for information on how to use the `@StandardActor` property wrapper. Do not use the `_StandardPropertyWrapper` directly.
    public init() { }
    
    
    func inject(standard: S) {
        self.standard = standard
    }
}
