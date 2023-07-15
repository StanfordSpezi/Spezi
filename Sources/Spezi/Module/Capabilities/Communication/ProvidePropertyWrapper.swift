//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


protocol AnyStorageValueCollector { // TODO move and generalize (maybe even public?)!
    func collect<Repository: SharedRepository<SpeziAnchor>>(into repository: Repository)
}

extension Component {
    var storageValueCollectors: [AnyStorageValueCollector] {
        retrieveProperties(ofType: AnyStorageValueCollector.self)
    }

    func collectComponentValues<Repository: SharedRepository<SpeziAnchor>>(into repository: Repository) {
        for collector in storageValueCollectors {
            collector.collect(into: repository)
        }
    }
}

// TODO move
struct CollectedComponentValue<ComponentValue>: DefaultProvidingKnowledgeSource {
    typealias Anchor = SpeziAnchor

    // TODO can the value be a reference type that is shared between all and which can be subscribed to?
    typealias Value = [ComponentValue]

    static var defaultValue: [ComponentValue] {
        []
    }
}

@propertyWrapper
public class _ProvidePropertyWrapper<Value>: AnyStorageValueCollector {
    // swiftlint:disable:previous type_name
    // We want the type to be hidden from autocompletion and documentation generation

    private var storedValue: Value

    public var wrappedValue: Value {
        get {
            storedValue
        }
        set {
            storedValue = newValue
            // TODO either prevent updates after collection, or have them update still?
        }
    }


    // TODO document how you can use an optional to not provide a value instantly?
    public init(wrappedValue value: Value) {
        self.storedValue = value
    }

    func collect<Repository: SharedRepository<SpeziAnchor>>(into repository: Repository) {
        if let wrapperWithOptional = self as? OptionalBasedProvideProperty {
            wrapperWithOptional.collectOptional(into: repository)
        } else if let wrapperWithArray = self as? ArrayBasedProvideProperty {
            wrapperWithArray.collectArrayElements(into: repository)
        } else {
            // TODO reducible!
            if var existing = repository[CollectedComponentValue<Value>.self] {
                existing.append(storedValue)
                repository[CollectedComponentValue<Value>.self] = existing
            } else {
                repository[CollectedComponentValue<Value>.self] = [storedValue]
            }
        }
    }
}

// TODO pull out the optional?
protocol ArrayBasedProvideProperty {
    func collectArrayElements<Repository: SharedRepository<SpeziAnchor>>(into repository: Repository)
}

protocol OptionalBasedProvideProperty {
    func collectOptional<Repository: SharedRepository<SpeziAnchor>>(into repository: Repository)
}

extension _ProvidePropertyWrapper: ArrayBasedProvideProperty where Value: Collection {
    func collectArrayElements<Repository: SharedRepository<SpeziAnchor>>(into repository: Repository) {
        // TODO repated code!
        if var existing = repository[CollectedComponentValue<Value.Element>.self] {
            existing.append(contentsOf: storedValue)
            repository[CollectedComponentValue<Value.Element>.self] = existing
        } else {
            repository[CollectedComponentValue<Value.Element>.self] = Array(storedValue)
        }
    }
}

extension _ProvidePropertyWrapper: OptionalBasedProvideProperty where Value: AnyOptional {
    func collectOptional<Repository: SharedRepository<SpeziAnchor>>(into repository: Repository) {
        guard let storedValue = storedValue.unwrappedOptional else {
            return
        }

        // TODO repated code!
        if var existing = repository[CollectedComponentValue<Value.Wrapped>.self] {
            existing.append(storedValue)
            repository[CollectedComponentValue<Value.Wrapped>.self] = existing
        } else {
            repository[CollectedComponentValue<Value.Wrapped>.self] = [storedValue]
        }
    }
}

extension Component {
    public typealias Provide = _ProvidePropertyWrapper
}
