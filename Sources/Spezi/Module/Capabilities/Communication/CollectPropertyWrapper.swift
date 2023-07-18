//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import XCTRuntimeAssertions


@propertyWrapper
public class _CollectPropertyWrapper<Value> {
    // swiftlint:disable:previous type_name
    // We want the type to be hidden from autocompletion and documentation generation

    private var injectedValues: [Value]?

    public var wrappedValue: [Value] {
        guard let values = injectedValues else {
            preconditionFailure("""
                                Tried to access @Collect for value [\(Value.self)] which wasn't injected yet. \
                                Are you sure that you are only accessing @Collect within the `Component/configure` method?
                                """)
        }

        return values
    }

    public init() {}
}


extension Component {
    public typealias Collect = _CollectPropertyWrapper
}


extension _CollectPropertyWrapper: StorageValueCollector {
    public func retrieve<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository) {
        injectedValues = repository[CollectedComponentValue<Value>.self]
    }
}
