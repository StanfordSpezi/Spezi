//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A protocol that identifies a ``_ProvidePropertyWrapper`` which `Value` type is a `Collection`.
protocol CollectionBasedProvideProperty {
    func collectArrayElements<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository)
}

/// A protocol that identifies a  ``_ProvidePropertyWrapper`` which `Value` type is a `Optional`.
protocol OptionalBasedProvideProperty {
    func collectOptional<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository)
}


// TODO docs!
@propertyWrapper
public class _ProvidePropertyWrapper<Value> {
    // swiftlint:disable:previous type_name
    // We want the type to be hidden from autocompletion and documentation generation

    // TODO implement some sort of storage base reference stuff, so we can update it?
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
}


extension Component {
    public typealias Provide = _ProvidePropertyWrapper
}


extension _ProvidePropertyWrapper: StorageValueProvider {
    public func collect<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository) {
        if let wrapperWithOptional = self as? OptionalBasedProvideProperty {
            wrapperWithOptional.collectOptional(into: &repository)
        } else if let wrapperWithArray = self as? CollectionBasedProvideProperty {
            wrapperWithArray.collectArrayElements(into: &repository)
        } else {
            // TODO reducible!
            store(value: storedValue, into: &repository)
        }
    }

    // stores a single value in the repository
    func store<StoredValue, Repository: SharedRepository<SpeziAnchor>>(value: StoredValue, into repository: inout Repository) {
        if var existing = repository[CollectedComponentValue<StoredValue>.self] {
            existing.append(value)
            repository[CollectedComponentValue<StoredValue>.self] = existing
        } else {
            repository[CollectedComponentValue<StoredValue>.self] = [value]
        }
    }

    // stores all values of a collection in the repository
    func store<StoredValue, Repository: SharedRepository<SpeziAnchor>>(values: any Collection<StoredValue>, into repository: inout Repository) {
        if var existing = repository[CollectedComponentValue<StoredValue>.self] {
            existing.append(contentsOf: values)
            repository[CollectedComponentValue<StoredValue>.self] = existing
        } else {
            repository[CollectedComponentValue<StoredValue>.self] = Array(values)
        }
    }
}

extension _ProvidePropertyWrapper: CollectionBasedProvideProperty where Value: Collection {
    func collectArrayElements<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository) {
        store(values: storedValue, into: &repository)
    }
}

extension _ProvidePropertyWrapper: OptionalBasedProvideProperty where Value: AnyOptional {
    func collectOptional<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository) {
        if let storedValue = storedValue.unwrappedOptional {
            store(value: storedValue, into: &repository)
        }
    }
}
