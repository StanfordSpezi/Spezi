//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Standard {
    nonisolated func inject(dataStorageProviders: [any DataStorageProvider<Self>]) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let standardPropertyWrapper = child.value as? DataStorageProviders else {
                continue
            }
            standardPropertyWrapper.inject(dataStorageProviders: dataStorageProviders)
        }
    }
}


extension Standard {
    /// <#Description#>
    public typealias DataStorageProviders = _DataStorageProvidersPropertyWrapper<Self>
}
