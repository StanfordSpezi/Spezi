//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation


/// An adopter of this protocol is a property of a ``Module`` that provides mechanisms to communicate
/// data with other ``Module``s.
///
/// Data provided through a Storage Value Provider can be retrieved through a ``_StorageValueCollector``.
protocol StorageValueProvider {
    /// This method is called to collect all provided values into the given ``SpeziStorage`` repository.
    /// - Parameter repository: Provides access to the ``SpeziStorage`` repository.
    func collect<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository)
}


extension Module {
    var storageValueProviders: [StorageValueProvider] {
        retrieveProperties(ofType: StorageValueProvider.self)
    }

    func collectModuleValues<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository) {
        for provider in storageValueProviders {
            provider.collect(into: &repository)
        }
    }
}
