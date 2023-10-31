//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``ModuleDependency`` defines the interface of a ``Module/Dependency`` property wrapper.
public protocol ModuleDependency: DependencyDescriptor, AnyObject {
    /// The type of the module that is defined as a dependency.
    associatedtype ModuleType: Module
    
    
    /// The default value defined by the ``Module`` describing the dependency.
    var defaultValue: () -> ModuleType { get }
    /// The resolved dependency provided by the ``Module/Dependency`` property wrapper.
    var wrappedValue: ModuleType { get }
    
    
    /// Inject a resolved ``ModuleDependency/ModuleType`` instance in the property wrapper.
    func inject(dependency: ModuleType)
}
