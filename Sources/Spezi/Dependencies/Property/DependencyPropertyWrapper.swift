//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation
import XCTRuntimeAssertions


/// A `@Dependency` for a single, typed ``Module``.
private protocol SingleModuleDependency {
    func wrappedValue<WrappedValue>(as value: WrappedValue.Type) -> WrappedValue
}


/// A `@Dependency` for a single, optional ``Module``.
private protocol OptionalModuleDependency {
    func wrappedValue<WrappedValue>(as value: WrappedValue.Type) -> WrappedValue
}


/// A `@Dependency` for an array of ``Module``s.
private protocol ModuleArrayDependency {
    func wrappedValue<WrappedValue>(as value: WrappedValue.Type) -> WrappedValue
}


/// Refer to the documentation of ``Module/Dependency`` for information on how to use the `@Dependency` property wrapper.
@propertyWrapper
public class _DependencyPropertyWrapper<Value> { // swiftlint:disable:this type_name
    private weak var spezi: Spezi?
    private let dependencies: DependencyCollection

    /// The dependency value.
    public var wrappedValue: Value {
        if let singleModule = self as? SingleModuleDependency {
            return singleModule.wrappedValue(as: Value.self)
        } else if let moduleArray = self as? ModuleArrayDependency {
            return moduleArray.wrappedValue(as: Value.self)
        } else if let optionalModule = self as? OptionalModuleDependency {
            return optionalModule.wrappedValue(as: Value.self)
        }

        preconditionFailure("Reached inconsistent state. Wrapped value must be of type `Module`, `Module?` or `[any Module]`!")
    }


    fileprivate init(_ dependencies: DependencyCollection) {
        self.dependencies = dependencies
    }

    fileprivate convenience init<T>(_ context: DependencyContext<T>) {
        self.init(DependencyCollection(context))
    }

    /// Create an optional dependency.
    /// - Parameter dependencyType: The wrapped type of the optional dependency.
    public convenience init<T>(_ dependencyType: T.Type) where Value == T?, T: Module {
        self.init(DependencyCollection(DependencyContext(for: T.self, type: .optional)))
    }

    /// Create an optional dependency with a default value.
    /// - Parameters:
    ///   - dependencyType: The wrapped type of the optional dependency.
    ///   - defaultValue: The default value that is used if no instance was supplied otherwise.
    public convenience init<T>(
        wrappedValue defaultValue: @escaping @autoclosure () -> T,
        _ dependencyType: T.Type = T.self
    ) where Value == T?, T: Module {
        self.init(DependencyContext(for: T.self, type: .optional, defaultValue: defaultValue))
    }

    /// Declare a dependency to a module that can provide a default value on its own.
    @available(
        *, deprecated, renamed: "init(_:)",
         message: "Please explicitly specify the Module type."
    )
    public convenience init() where Value: DefaultInitializable & Module {
        // we probably want to remove this init in the next major release

        // this init is placed here directly, otherwise Swift has problems resolving this init
        self.init(wrappedValue: Value())
    }

    deinit {
        guard let spezi = spezi else {
            return
        }
        nonIsolatedUninjectDependencies(notifying: spezi)
    }
}


extension _DependencyPropertyWrapper: SpeziPropertyWrapper {
    func inject(spezi: Spezi) {
        self.spezi = spezi
        dependencies.inject(spezi: spezi)
    }

    func clear() {
        guard let spezi else {
            preconditionFailure("\(Self.self) was clear without a Spezi instance available")
        }
        uninjectDependencies(notifying: spezi)
    }
}


extension _DependencyPropertyWrapper: DependencyDeclaration {
    var unsafeInjectedModules: [any Module] {
        dependencies.unsafeInjectedModules
    }
    
    func dependencyRelation(to module: DependencyReference) -> DependencyRelation {
        dependencies.dependencyRelation(to: module)
    }

    func collect(into dependencyManager: DependencyManager) throws(DependencyManagerError) {
        try dependencies.collect(into: dependencyManager)
    }

    func inject(from dependencyManager: DependencyManager, for module: any Module) throws(DependencyManagerError) {
        try dependencies.inject(from: dependencyManager, for: module)
    }

    func uninjectDependencies(notifying spezi: Spezi) {
        dependencies.uninjectDependencies(notifying: spezi)
    }

    func nonIsolatedUninjectDependencies(notifying spezi: Spezi) {
        dependencies.nonIsolatedUninjectDependencies(notifying: spezi)
    }
}


extension _DependencyPropertyWrapper: SingleModuleDependency where Value: Module {
    /// Create a required dependency.
    ///
    /// If the dependency conforms to ``DefaultInitializable`` a default value is automatically supplied, if the module is not found to be configured.
    /// - Parameter dependencyType: The wrapped type of the dependency.
    public convenience init(_ dependencyType: Value.Type) {
        self.init(DependencyContext(for: Value.self, type: .required))
    }

    /// Create a required dependency with a default value.
    /// - Parameters:
    ///   - dependencyType: The wrapped type of the dependency.
    ///   - defaultValue: The default value that is used if no instance was supplied otherwise.
    public convenience init(
        wrappedValue defaultValue: @escaping @autoclosure () -> Value,
        _ dependencyType: Value.Type = Value.self
    ) {
        self.init(DependencyContext(for: Value.self, type: .required, defaultValue: defaultValue))
    }

    public convenience init(load dependency: Value, _ dependencyType: Value.Type = Value.self) {
        self.init(DependencyContext(for: Value.self, type: .load, defaultValue: { dependency }))
    }
    
    fileprivate func wrappedValue<WrappedValue>(as value: WrappedValue.Type) -> WrappedValue {
        dependencies.singleDependencyRetrieval()
    }
}


extension _DependencyPropertyWrapper: OptionalModuleDependency where Value: AnyOptional, Value.Wrapped: Module {
    /// Create a empty, optional dependency.
    @available(*, deprecated, renamed: "init(_:)", message: "Please specify the Wrapped type of your optional dependency as the first argument.")
    public convenience init() {
        self.init(DependencyCollection(DependencyContext(for: Value.Wrapped.self, type: .optional)))
    }


    fileprivate func wrappedValue<WrappedValue>(as value: WrappedValue.Type) -> WrappedValue {
        guard let value = dependencies.singleOptionalDependencyRetrieval(for: Value.Wrapped.self) as? WrappedValue else {
            preconditionFailure("Failed to convert from Optional<\(Value.Wrapped.self)> to \(WrappedValue.self)")
        }
        return value
    }
}


extension _DependencyPropertyWrapper: ModuleArrayDependency where Value == [any Module] {
    /// Initialize an empty collection of dependencies.
    @_disfavoredOverload
    public convenience init() {
        self.init(DependencyCollection())
    }

    /// Create a dependency from a ``DependencyCollection``.
    ///
    /// Creates the `@Dependency` property wrapper from an instantiated ``DependencyCollection``,
    /// enabling the use of a custom ``DependencyBuilder`` enforcing certain type constraints on the passed, nested ``Dependency``s.
    ///
    /// ### Usage
    ///
    /// The `ExampleModule` is initialized with nested ``Module/Dependency``s (``Module``s) enforcing certain type constraints via the `SomeCustomDependencyBuilder`.
    /// Spezi automatically injects declared ``Dependency``s within the passed ``Dependency``s in the initializer, enabling proper nesting of ``Module``s.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Dependency var dependentModules: [any Module]
    ///
    ///     init(@SomeCustomDependencyBuilder _ dependencies: () -> DependencyCollection) {
    ///         self._dependentModules = Dependency(using: dependencies())
    ///     }
    /// }
    /// ```
    ///
    /// See ``DependencyCollection/init(for:singleEntry:)`` for a continued example, specifically the implementation of the `SomeCustomDependencyBuilder` result builder.
    ///
    /// - Parameters:
    ///    - dependencies: The ``DependencyCollection``.
    public convenience init(using dependencies: DependencyCollection) {
        self.init(dependencies)
    }

    /// Create a dependency from a list of dependencies.
    /// - Parameter dependencies: The result builder to build the dependency tree.
    public convenience init(@DependencyBuilder _ dependencies: () -> DependencyCollection) {
        self.init(dependencies())
    }
    

    fileprivate func wrappedValue<WrappedValue>(as value: WrappedValue.Type) -> WrappedValue {
        guard let modules = dependencies.retrieveModules() as? WrappedValue else {
            preconditionFailure("\(WrappedValue.self) doesn't match expected type \(Value.self)")
        }
        return modules
    }
}
