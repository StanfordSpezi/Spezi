//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
@propertyWrapper
public class _DataStorageProvidersPropertyWrapper<S: Standard> {
    // swiftlint:disable:previous type_name
    // We want the _DependencyPropertyWrapper type to be hidden from autocompletion and document generation.
    
    // We use a optional collection here to clearly differentiate between an non-initialized version and an injected instance.
    // swiftlint:disable:next discouraged_optional_collection
    private var dataStorageProviders: [any DataStorageProvider<S>]?
    
    
    /// <#Description#>
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
    
    
    /// <#Description#>
    public init() { }
    
    
    func inject(dataStorageProviders: [any DataStorageProvider<S>]) {
        self.dataStorageProviders = dataStorageProviders
    }
}
