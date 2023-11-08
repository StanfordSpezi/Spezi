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
public class _DependencyPropertyWrapper<Value>: DependencyDeclaration { // swiftlint:disable:this type_name
    private let dependencies: DependencyCollection

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

    public convenience init() where Value: Module & DefaultInitializable {
        // this init is placed here directly, otherwise Swift has problems resolving this init
        self.init(wrappedValue: Value())
    }


    func collect(into dependencyManager: DependencyManager) {
        dependencies.collect(into: dependencyManager)
    }

    func inject(from dependencyManager: DependencyManager) {
        dependencies.inject(from: dependencyManager)
    }
}


extension _DependencyPropertyWrapper: SingleModuleDependency where Value: Module {
    public convenience init(wrappedValue defaultValue: @escaping @autoclosure () -> Value) {
        self.init(DependencyCollection(DependencyContext(defaultValue: defaultValue)))
    }


    func wrappedValue<WrappedValue>(as value: WrappedValue.Type) -> WrappedValue {
        dependencies.singleDependencyRetrieval()
    }
}


extension _DependencyPropertyWrapper: OptionalModuleDependency where Value: AnyOptional, Value.Wrapped: Module {
    public convenience init() {
        self.init(DependencyCollection(DependencyContext(for: Value.Wrapped.self)))
    }


    func wrappedValue<WrappedValue>(as value: WrappedValue.Type) -> WrappedValue {
        guard let value = dependencies.singleOptionalDependencyRetrieval(for: Value.Wrapped.self) as? WrappedValue else {
            preconditionFailure("Failed to convert from Optional<\(Value.Wrapped.self)> to \(WrappedValue.self)")
        }
        return value
    }
}


extension _DependencyPropertyWrapper: ModuleArrayDependency where Value == [any Module] {
    public convenience init() {
        self.init(DependencyCollection())
    }


    public convenience init(@DependencyBuilder _ dependencies: () -> DependencyCollection) {
        self.init(dependencies())
    }

    func wrappedValue<WrappedValue>(as value: WrappedValue.Type) -> WrappedValue {
        guard let modules = dependencies.retrieveModules() as? WrappedValue else {
            preconditionFailure("\(WrappedValue.self) doesn't match expected type \(Value.self)")
        }
        return modules
    }
}
