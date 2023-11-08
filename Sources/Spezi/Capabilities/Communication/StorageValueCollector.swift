//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation


/// An adopter of this protocol is a property of a ``Module`` that provides mechanisms to retrieve
/// data provided by other ``Module``s.
///
/// Data requested through a Storage Value Collector might be provided through a ``_StorageValueProvider``.
protocol StorageValueCollector {
    /// This method is called to retrieve all the requested values from the given ``SpeziStorage`` repository.
    /// - Parameter repository: Provides access to the ``SpeziStorage`` repository for read access.
    func retrieve<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository)
}


extension Module {
    var storageValueCollectors: [StorageValueCollector] {
        retrieveProperties(ofType: StorageValueCollector.self)
    }

    func injectModuleValues<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository) {
        for collector in storageValueCollectors {
            collector.retrieve(from: repository)
        }
    }
}
