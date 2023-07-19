//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A adopter of this protocol is a property of a ``Component`` that provides mechanisms to retrieve
/// data provided by other ``Component``s.
///
/// Data requested through a Storage Value Collector might be provided through a ``_StorageValueProvider``.
public protocol _StorageValueCollector {
    // swiftlint:disable:previous type_name
    // to be hidden from documentation

    /// This method is called to retrieve all the requested values from the given ``SpeziStorage`` repository.
    /// - Parameter repository: Provides access to the ``SpeziStorage`` repository for read access.
    func retrieve<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository)
}


extension Component {
    var storageValueCollectors: [_StorageValueCollector] {
        retrieveProperties(ofType: _StorageValueCollector.self)
    }

    func injectComponentValues<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository) {
        for collector in storageValueCollectors {
            collector.retrieve(from: repository)
        }
    }
}
