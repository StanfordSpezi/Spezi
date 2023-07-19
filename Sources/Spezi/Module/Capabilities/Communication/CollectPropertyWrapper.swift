//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTRuntimeAssertions


/// Refer to the documentation of ``Component/Collect``.
@propertyWrapper
public class _CollectPropertyWrapper<Value> {
    // swiftlint:disable:previous type_name
    // We want the type to be hidden from autocompletion and documentation generation

    private var injectedValues: [Value]? // swiftlint:disable:this discouraged_optional_collection

    /// Access the collected values.
    /// - Note: The property is only accessible within the ``Component/configure()`` method.
    public var wrappedValue: [Value] {
        guard let values = injectedValues else {
            preconditionFailure("""
                                Tried to access @Collect for value [\(Value.self)] which wasn't injected yet. \
                                Are you sure that you are only accessing @Collect within the `Component/configure` method?
                                """)
        }

        return values
    }

    /// Initialize a new `@Collect` property wrapper.
    public init() {}
}

/// A adopter of this protocol is a property of a ``Component`` that provides mechanisms to retrieve
/// data provided by other ``Component``s.
///
/// Data requested through a Storage Value Collector might be provided through a ``StorageValueProvider``.


extension Component {
    /// The `@Collect` property wrapper can be used to retrieve data communicated by other ``Component``s by
    /// retrieving them from the central ``SpeziStorage`` repository.
    ///
    /// **Retrieving Data**
    /// ``Component/Collect`` retrieves data provided through the ``Component/Provide`` property wrapper.
    /// You declare `@Collect` as an Array with a given type. The type is used to match `@Provide` properties.
    ///
    /// Below is an example where the `ExampleComponent` collects an array of `Numeric` types from all other `Components`.
    ///
    /// ```swift
    /// class ExampleComponent<ComponentStandard: Standard>: Component {
    ///     @Collect var favoriteNumbers: [Numeric]
    ///
    ///     func configure() {
    ///         // you can safely access `favoriteNumbers` inside the configure method.
    ///     }
    /// }
    /// ```
    ///
    /// - Note: The property is only accessible within the ``Component/configure()`` method.
    public typealias Collect = _CollectPropertyWrapper
}


extension _CollectPropertyWrapper: StorageValueCollector {
    public func retrieve<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository) {
        injectedValues = repository[CollectedComponentValue<Value>.self] ?? []
    }
}
