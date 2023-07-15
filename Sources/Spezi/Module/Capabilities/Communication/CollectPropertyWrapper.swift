//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation

extension Component { // TODO move this extension somewhere else!
    func retrieveProperties<Value>(ofType type: Value.Type) -> [Value] {
        let mirror = Mirror(reflecting: self)

        return mirror.children.compactMap { _, value in
            value as? Value
        }
    }
}

protocol AnyStorageValueProvider { // TODO move and generalize (maybe even public?)!
    func provide<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository)
}

extension Component {
    var storageValueProviders: [AnyStorageValueProvider] {
        retrieveProperties(ofType: AnyStorageValueProvider.self)
    }

    // TODO all the namings?
    func injectComponentValues<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository) {
        for providers in storageValueProviders {
            providers.provide(from: repository)
        }
    }
}

// TODO just return empty whatever?
@propertyWrapper
public class _CollectPropertyWrapper<Value>: AnyStorageValueProvider {
    // swiftlint:disable:previous type_name
    // We want the type to be hidden from autocompletion and documentation generation

    // TODO storage
    private var injectedValues: [Value]? // TODO we might support singular values with a reducible?

    public var wrappedValue: [Value] {
        guard let values = injectedValues else {
            fatalError("Something went wrong") // TODO message
        }

        return values
    }

    public init() {}

    func provide<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository) {
        injectedValues = repository[CollectedComponentValue<Value>.self]
    }
}

extension Component {
    public typealias Collect = _CollectPropertyWrapper
}
