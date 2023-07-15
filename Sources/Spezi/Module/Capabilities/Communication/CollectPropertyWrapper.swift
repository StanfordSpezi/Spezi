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

protocol AnyCollectPropertyWrapper {
    func provide<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository)
}

extension Component {
    var collectPropertyWrappers: [AnyCollectPropertyWrapper] {
        retrieveProperties(ofType: AnyCollectPropertyWrapper.self)
    }

    // TODO all the namings?
    func injectComponentValues<Repository: SharedRepository<SpeziAnchor>>(from repository: Repository) {
        for collect in collectPropertyWrappers {
            collect.provide(from: repository)
        }
    }
}

// TODO just return empty whatever?
@propertyWrapper
public class _CollectPropertyWrapper<Value>: AnyCollectPropertyWrapper {
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
        injectedValues = repository[ProvidedComponentValue<Value>.self]
    }
}

extension Component {
    public typealias Collect = _CollectPropertyWrapper
}
