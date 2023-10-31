//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTRuntimeAssertions


/// Refer to ``Module/Dependency`` for information on how to use the `@Dependency` property wrapper. Do not use the `_DependencyPropertyWrapper` directly.
@propertyWrapper
public class _DependencyPropertyWrapper<M: Module>: ModuleDependency {
    // swiftlint:disable:previous type_name
    // We want the _DependencyPropertyWrapper type to be hidden from autocompletion and document generation.
    
    public let defaultValue: () -> M
    private var dependency: M?
    
    
    /// The dependency that is resolved by ``Spezi``
    public var wrappedValue: M {
        guard let dependency else {
            preconditionFailure(
                """
                A `_DependencyPropertyWrapper`'s wrappedValue was accessed before the dependency was activated.
                Only access dependencies once the module has been configured and the Spezi initialization is complete.
                """
            )
        }
        return dependency
    }
    
    
    /// Refer to ``Module/Dependency`` for information on how to use the `@Dependency` property wrapper. Do not use the `_DependencyPropertyWrapper` directly.
    public init(wrappedValue defaultValue: @escaping @autoclosure () -> M) {
        self.defaultValue = defaultValue
    }
    
    
    /// Refer to ``Module/Dependency`` for information on how to use the `@Dependency` property wrapper. Do not use the `_DependencyPropertyWrapper` directly.
    public init() where M: DefaultInitializable {
        self.defaultValue = { M() }
    }
    
    
    public func gatherDependency(dependencyManager: DependencyManager) {
        dependencyManager.require(M.self, defaultValue: defaultValue())
    }
    
    public func inject(dependencyManager: DependencyManager) {
        dependencyManager.inject(M.self, into: self)
    }
    
    public func inject(dependency: M) {
        precondition(
            self.dependency == nil,
            "Already injected a module: \(String(describing: dependency))"
        )
        self.dependency = dependency
    }
}
