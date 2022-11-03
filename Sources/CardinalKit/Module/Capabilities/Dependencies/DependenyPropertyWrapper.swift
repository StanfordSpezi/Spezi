//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTRuntimeAssertions


/// Refer to ``Component/Dependency`` for information on how to use the `@Dependency` property wrapper. Do not use the `_DependencyPropertyWrapper` directly.
@propertyWrapper
public class _DependencyPropertyWrapper<C: Component, S: Standard>: DependencyInjectable where C.ComponentStandard == S {
    // swiftlint:disable:previous type_name
    // We want the _DependencyPropertyWrapper type to be hidden from autocompletion and document generation.
    
    typealias DependencyInjectableStandard = S
    
    
    private let defaultValue: () -> C
    var dependency: C?
    
    /// The dependency that is resolved by ``CardinalKit``
    public var wrappedValue: C {
        guard let dependency else {
            preconditionFailure(
                """
                A `_DependencyPropertyWrapper`'s wrappedValue was accessed before the dependency was activated.
                Only access dependencies once the component has been configured and the CardinalKit initialization is complete.
                """
            )
        }
        return dependency
    }
    
    
    /// Refer to ``Component/Dependency`` for information on how to use the `@Dependency` property wrapper. Do not use the `_DependencyPropertyWrapper` directly.
    public init(wrappedValue defaultValue: @escaping @autoclosure () -> C) {
        self.defaultValue = defaultValue
    }
    
    
    /// Refer to ``Component/Dependency`` for information on how to use the `@Dependency` property wrapper. Do not use the `_DependencyPropertyWrapper` directly.
    public init() where C: DefaultInitializable {
        self.defaultValue = { C() }
    }
    
    
    func gatherDependency(dependencyManager: DependencyManager<S>) {
        dependencyManager.require(C.self, defaultValue: defaultValue())
    }
    
    func inject(dependencyManager: DependencyManager<S>) {
        dependencyManager.inject(C.self, into: self)
    }
}
