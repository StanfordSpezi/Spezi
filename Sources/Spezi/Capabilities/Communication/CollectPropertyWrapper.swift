//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation
import XCTRuntimeAssertions


/// Refer to the documentation of ``Module/Collect``.
@propertyWrapper
public class _CollectPropertyWrapper<Value> {
    // swiftlint:disable:previous type_name
    // We want the type to be hidden from autocompletion and documentation generation

    private var injectedValues: [Value]? // swiftlint:disable:this discouraged_optional_collection


    /// Access the collected values.
    /// - Note: The property is only accessible within the ``Module/configure()`` method.
    public var wrappedValue: [Value] {
        guard let values = injectedValues else {
            preconditionFailure("""
                                Tried to access @Collect for value [\(Value.self)] which wasn't injected yet. \
                                Are you sure that you are only accessing @Collect within the `Module/configure` method?
                                """)
        }

        return values
    }


    /// Initialize a new `@Collect` property wrapper.
    public init() {}
}


extension Module {
    /// The `@Collect` property wrapper can be used to retrieve data communicated by other `Module`s.
    ///
    /// The `@Collect` modifier can be used a establish a data flow between ``Module``s without requiring a dependency relationship.
    /// `@Collect` declares the receiving end.
    ///
    /// - Important: The property is only accessible once your ``Module/configure()-5pa83`` method is called.
    ///
    /// ### Retrieving Data
    /// ``Module/Collect`` retrieves data provided through the ``Module/Provide`` property wrapper.
    /// You declare `@Collect` as an Array with a given type. The type is used to match `@Provide` properties.
    ///
    /// Below is an example where the `ExampleModule` collects an array of `Numeric` types from all other `Modules`.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Collect var favoriteNumbers: [Numeric]
    ///
    ///     func configure() {
    ///         // you can safely access `favoriteNumbers` inside the configure method.
    ///     }
    /// }
    /// ```
    public typealias Collect = _CollectPropertyWrapper
}


extension _CollectPropertyWrapper: StorageValueCollector {
    public func retrieve<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository) {
        injectedValues = repository[CollectedModuleValue<Value>.self] ?? []
    }
}
