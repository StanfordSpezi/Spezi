//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import Foundation
import RuntimeAssertions
import SpeziFoundation


/// A protocol that identifies a ``_ProvidePropertyWrapper`` which `Value` type is a `Collection`.
protocol CollectionBasedProvideProperty {
    func collectArrayElements<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository)

    func clearValues(isolated: Bool)
}


/// A protocol that identifies a  ``_ProvidePropertyWrapper`` which `Value` type is a `Optional`.
protocol OptionalBasedProvideProperty {
    func collectOptional<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository)

    func clearValues(isolated: Bool)
}


/// Refer to the documentation of ``Module/Provide``.
@propertyWrapper
public final class _ProvidePropertyWrapper<Value> {
    // swiftlint:disable:previous type_name
    // We want the type to be hidden from autocompletion and documentation generation

    /// Persistent identifier to store and remove @Provide values.
    fileprivate let id = UUID()

    private var storedValue: Value
    private var collected = false


    private weak var spezi: Spezi?


    /// Access the store value.
    /// - Note: You cannot access the value once it was collected.
    public var wrappedValue: Value {
        get {
            storedValue
        }
        set {
            precondition(!collected, "You cannot update a @Provide property after it was already collected.")
            storedValue = newValue
        }
    }


    /// Initialize a new `@Provide` property wrapper.
    /// - Parameter value: The initial value.
    public init(wrappedValue value: Value) {
        self.storedValue = value
    }

    func inject(spezi: Spezi) {
        self.spezi = spezi
    }


    deinit {
        clear(isolated: false)
    }
}


extension Module {
    /// The `@Provide` property wrapper can be used to communicate data with other `Module`s.
    ///
    /// The `@Provide` modifier can be used a establish a data flow between ``Module``s without requiring a dependency relationship.
    ///
    /// - Important: All `@Provide` properties must be initialized within the initializer and cannot be modified within the
    ///     ``Module/configure()-5pa83`` method.
    ///
    /// ### Providing Data
    /// Data provided through `@Provide` can be retrieved through the ``Module/Collect`` property wrapper.
    ///
    /// - Note: that the declaring type has to match what is requested by the other side (e.g., a common protocol implementation)
    ///
    /// Below is an example where the `ExampleModule` provides a `Numeric` type to some other modules.
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Provide var favoriteNumber: Numeric
    ///
    ///     init() {
    ///         favoriteNumber = 42
    ///     }
    /// }
    /// ```
    ///
    /// ### Provide Conditionally
    /// You can conditionally provide data by using an `Optional` type for the property wrapper.
    /// If `nil` is provided, nothing is collected, otherwise the underlying value of the optional is collected.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Provide var favoriteNumber: Numeric?
    ///
    ///     init() {
    ///         if someGlobalOption {
    ///             favoriteNumber = 42
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### Provide Multiple
    /// If you want to provide more than one instance of a given value you may declare @Provide as an `Array` type.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Provide var favoriteNumbers: [Numeric]
    ///
    ///     init() {
    ///         favoriteNumbers = [42, 3, 9]
    ///     }
    /// }
    /// ```
    public typealias Provide = _ProvidePropertyWrapper
}


extension _ProvidePropertyWrapper: StorageValueProvider {
    public func collect<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository) {
        if let wrapperWithOptional = self as? any OptionalBasedProvideProperty {
            wrapperWithOptional.collectOptional(into: &repository)
        } else if let wrapperWithArray = self as? any CollectionBasedProvideProperty {
            wrapperWithArray.collectArrayElements(into: &repository)
        } else {
            repository.setValues(for: id, [storedValue])
        }

        collected = true
    }

    @MainActor
    func clear() {
        clear(isolated: true)
    }

    private func clear(isolated: Bool) {
        collected = false

        if let wrapperWithOptional = self as? any OptionalBasedProvideProperty {
            wrapperWithOptional.clearValues(isolated: isolated)
        } else if let wrapperWithArray = self as? any CollectionBasedProvideProperty {
            wrapperWithArray.clearValues(isolated: isolated)
        } else {
            performClear(isolated: isolated, of: Value.self)
        }
    }

    private func performClear<V>(isolated: Bool, of type: V.Type) {
        if isolated {
            MainActor.assumeIsolated { [spezi, id] in
                spezi?.handleCollectedValueRemoval(for: id, of: type)
            }
        } else {
            Task { @MainActor [spezi, id] in
                spezi?.handleCollectedValueRemoval(for: id, of: type)
            }
        }
    }
}


extension _ProvidePropertyWrapper: CollectionBasedProvideProperty where Value: AnyArray {
    func collectArrayElements<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository) {
        repository.setValues(for: id, storedValue.unwrappedArray)
    }

    func clearValues(isolated: Bool) {
        performClear(isolated: isolated, of: Value.Element.self)
    }
}


extension _ProvidePropertyWrapper: OptionalBasedProvideProperty where Value: AnyOptional {
    func collectOptional<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository) {
        if let storedValue = storedValue.unwrappedOptional {
            repository.setValues(for: id, [storedValue])
        }
    }

    func clearValues(isolated: Bool) {
        performClear(isolated: isolated, of: Value.Wrapped.self)
    }
}


extension SharedRepository where Anchor == SpeziAnchor {
    fileprivate mutating func setValues<Value>(for id: UUID, _ values: [Value]) {
        var current = self[CollectedModuleValues<Value>.self]
        current[id] = values
        self[CollectedModuleValues<Value>.self] = current
    }
}
