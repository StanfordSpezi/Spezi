//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//
//
// This code is based on the Vapor (https://github.com/vapor/vapor) and Apodini (https://github.com/Apodini/Apodini) projects.
//
// SPDX-FileCopyrightText: 2020 Qutheory, LLC, 2019-2021 Paul Schmiedmayer and the Apodini project authors
//
// SPDX-License-Identifier: MIT
//

import os


/// Type erasure for `TypedCollection.Value`
private protocol AnyTypedCollectionValue {
    var anyValue: Any { get }
    
    func shutdown(logger: Logger)
}


/// A typesafe `Collection` of arbitrary key value information
public class TypedCollection {
    private struct Value<T>: AnyTypedCollectionValue {
        var value: T
        var onShutdown: ((T) throws -> Void)?
        
        
        var anyValue: Any {
            value
        }
        
        
        func shutdown(logger: Logger) {
            do {
                try self.onShutdown?(self.value)
            } catch {
                logger.error("Could not shutdown \(T.self): \(error)")
            }
        }
    }
    
    
    private var typedCollection: [ObjectIdentifier: AnyTypedCollectionValue]
    private let logger: Logger
    
    
    /// Initialize a `TypedCollection` instance.
    /// - Parameter logger: A logger used to log events in the `TypedCollection` instance.
    init(logger: Logger = Logger(subsystem: "edu.stanford.cardinalkit.typedCollection", category: "typedCollection")) {
        self.typedCollection = [:]
        self.logger = logger
    }
    
    
    /// Clear the `TypedCollection` instance.
    func clear() {
        self.typedCollection = [:]
    }

    /// Check if  the `TypedCollection` instance contains a key.
    /// - Parameter key: The metatype used as a key in the `TypedCollection` instance.
    /// - Returns: `true` of the `TypedCollection` instance contains a value for the `key`. `false` if there is no value present.
    public func contains<Key>(_ key: Key.Type) -> Bool {
        self.typedCollection.keys.contains(ObjectIdentifier(Key.self))
    }

    /// Get the value corresponding to a key.
    /// - Parameter key: The metatype used as a key in the `TypedCollection` instance.
    /// - Returns: The value for the `key` stored in the `TypedCollection` instance.
    public func get<Key: TypedCollectionKey>(_ key: Key.Type) -> Key.Value? {
        guard let value = self.typedCollection[ObjectIdentifier(Key.self)] as? Value<Key.Value> else {
            return nil
        }
        return value.value
    }
    
    /// Get the value corresponding to a key or stores and returns a value defined by the passed in default value.
    /// - Parameter key: The metatype used as a key in the `TypedCollection` instance.
    /// - Returns: The value for the `key` stored in the `TypedCollection` instance or the value defined by the passed in default value.
    public func get<Key: TypedCollectionKey>(_ key: Key.Type, default defaultValue: @autoclosure () -> Key.Value) -> Key.Value {
        guard let value = self.typedCollection[ObjectIdentifier(Key.self)] as? Value<Key.Value> else {
            set(key, to: defaultValue())
            return get(key, default: defaultValue())
        }
        return value.value
    }
    
    /// Get all values in the `TypedCollection` instance that conform to a specific type.
    /// - Parameter allThatConformTo: The type that the returned instances should conform to.
    /// - Returns: Returns an `Array` of all types in the `TypedCollection` instance conforming to the specified type.
    public func get<Key>(allThatConformTo: Key.Type) -> [Key] {
        typedCollection.values.compactMap {
            $0.anyValue as? Key
        }
    }

    /// Set a value for a key in the `TypedCollection` instance.
    /// - Parameters:
    ///   - key: he metatype used as a key in the `TypedCollection` instance.
    ///   - value: The value that will be stored for the `key` stored in the `TypedCollection` instance.
    ///   - onShutdown: An optional closure that is called when the `TypedCollection` is shut down.
    public func set<Key: TypedCollectionKey>(
        _ key: Key.Type,
        to value: Key.Value?,
        onShutdown: ((Key.Value) throws -> Void)? = nil
    ) {
        let key = ObjectIdentifier(Key.self)
        
        if let existing = self.typedCollection[key] {
            self.typedCollection[key] = nil
            existing.shutdown(logger: self.logger)
        }
        
        if let value = value {
            self.typedCollection[key] = Value(value: value, onShutdown: onShutdown)
        } else {
            self.typedCollection[key] = nil
        }
    }

    /// Call the shutdown closure for every stored element
    func shutdown() {
        self.typedCollection.values.forEach {
            $0.shutdown(logger: self.logger)
        }
    }
    
    
    subscript<Key: TypedCollectionKey>(key: Key.Type) -> Key.Value? {
        get {
            self.get(key)
        }
        set {
            self.set(key, to: newValue)
        }
    }
}
