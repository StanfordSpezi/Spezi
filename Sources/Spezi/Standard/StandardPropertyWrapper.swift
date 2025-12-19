//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import RuntimeAssertions


/// Refer to ``Module/StandardActor`` for information on how to use the `@StandardActor` property wrapper. Do not use the `_StandardPropertyWrapper` directly.
@propertyWrapper
public class _StandardPropertyWrapper<Constraint> {
    // swiftlint:disable:previous type_name
    // We want the _StandardPropertyWrapper type to be hidden from autocompletion and document generation.
    
    private enum LoadResult {
        case success(Constraint)
        case failure
    }
    
    private let load: (any Standard) -> LoadResult
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
    @_disfavoredOverload // needs to be downranked bc otherwise the optional init below would never get picked.
    public init(_ constraint: Constraint.Type = Constraint.self) {
        load = { (standard: any Standard) -> LoadResult in
            if let constraint = standard as? Constraint {
                .success(constraint)
            } else {
                .failure
            }
        }
    }
    
    /// Equivalent to `@StandardActor var standard: any Standard`.
    public convenience init() where Constraint == any Standard {
        self.init((any Standard).self)
    }
    
    /// Creates an `@StandardActor` with an optional constraint.
    ///
    /// If the standard does not conform to the protocol, the resulting property value is `nil`.
    ///
    /// ```swift
    /// @StandardActor var standard: (any HealthKitConstraint)?
    /// ```
    public init<C>(_ constraint: C.Type = C.self) where Constraint == C? {
        load = { (standard: any Standard) -> LoadResult in
            .success(standard as? C)
        }
    }
}


extension _StandardPropertyWrapper: SpeziPropertyWrapper {
    func inject(spezi: Spezi) throws(SpeziPropertyError) {
        // (lldb) po Constraint.self is any AnyOptional.Type
        switch load(spezi.standard) {
        case .success(let standard):
            self.standard = standard
        case .failure:
            let standardType = type(of: spezi.standard)
            throw SpeziPropertyError.unsatisfiedStandardConstraint(
                constraint: String(describing: Constraint.self),
                standard: String(describing: standardType)
            )
        }
    }

    func clear() {
        standard = nil
    }
}
