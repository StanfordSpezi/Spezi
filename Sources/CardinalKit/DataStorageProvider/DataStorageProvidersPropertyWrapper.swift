//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTRuntimeAssertions


/// Refer to ``Standard/DataStorageProviders`` for information on how to use the `@DataStorageProviders` property wrapper.
/// Do not use the `_DataStorageProvidersPropertyWrapper` directly.
@propertyWrapper
public class _DataStorageProvidersPropertyWrapper<S: Standard> {
    // swiftlint:disable:previous type_name
    // We want the _DependencyPropertyWrapper type to be hidden from autocompletion and document generation.
    
    // We use a optional collection here to clearly differentiate between an non-initialized version and an injected instance.
    // swiftlint:disable:next discouraged_optional_collection
    private var dataStorageProviders: [any DataStorageProvider<S>]?
    
    
    /// The injected ``[any DataStorageProvider<S>]`` that are resolved by ``CardinalKit``
    public var wrappedValue: [any DataStorageProvider<S>] {
        guard let dataStorageProviders else {
            preconditionFailure(
                """
                A `_DataStoragePropertyWrapper`'s wrappedValue was accessed before the `Standard` was configured.
                Only access dependencies once the component has been configured and the CardinalKit initialization is complete.
                """
            )
        }
        return dataStorageProviders
    }
    
    
    /// Refer to ``Standard/DataStorageProviders`` for information on how to use the `@DataStorageProviders` property wrapper.
    /// Do not use the `_DataStorageProvidersPropertyWrapper` directly.
    public init() { }
    
    
    func inject(dataStorageProviders: [any DataStorageProvider<S>]) {
        self.dataStorageProviders = dataStorageProviders
    }
}
