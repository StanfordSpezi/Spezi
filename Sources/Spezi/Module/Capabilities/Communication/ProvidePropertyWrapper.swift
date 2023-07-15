//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


// TODO AnyValueProvider
protocol AnyProvidePropertyWrapper {
    func collect<Repository: SharedRepository<SpeziAnchor>>(into repository: Repository)
}

extension Component {
    var providePropertyWrappers: [AnyProvidePropertyWrapper] {
        retrieveProperties(ofType: AnyProvidePropertyWrapper.self)
    }

    func collectComponentValues<Repository: SharedRepository<SpeziAnchor>>(into repository: Repository) {
        for provider in providePropertyWrappers {
            provider.collect(into: repository)
        }
    }
}

// TODO move
struct ProvidedComponentValue<ComponentValue>: DefaultProvidingKnowledgeSource {
    typealias Anchor = SpeziAnchor
    typealias Value = [ComponentValue]

    static var defaultValue: [ComponentValue] {
        []
    }
}

@propertyWrapper
public class _ProvidePropertyWrapper<Value>: AnyProvidePropertyWrapper {
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
            if var existing = repository[ProvidedComponentValue<Value>.self] {
                existing.append(storedValue)
                repository[ProvidedComponentValue<Value>.self] = existing
            } else {
                repository[ProvidedComponentValue<Value>.self] = [storedValue]
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
        if var existing = repository[ProvidedComponentValue<Value.Element>.self] {
            existing.append(contentsOf: storedValue)
            repository[ProvidedComponentValue<Value.Element>.self] = existing
        } else {
            repository[ProvidedComponentValue<Value.Element>.self] = Array(storedValue)
        }
    }
}

extension _ProvidePropertyWrapper: OptionalBasedProvideProperty where Value: AnyOptional {
    func collectOptional<Repository: SharedRepository<SpeziAnchor>>(into repository: Repository) {
        guard let storedValue = storedValue.unwrappedOptional else {
            return
        }

        // TODO repated code!
        if var existing = repository[ProvidedComponentValue<Value.Wrapped>.self] {
            existing.append(storedValue)
            repository[ProvidedComponentValue<Value.Wrapped>.self] = existing
        } else {
            repository[ProvidedComponentValue<Value.Wrapped>.self] = [storedValue]
        }
    }
}

extension Component {
    public typealias Provide = _ProvidePropertyWrapper
}
