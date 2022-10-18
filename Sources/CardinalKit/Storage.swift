//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
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


/// Key used to identify stored elements in `Storage` instances.
protocol StorageKey {
    /// The value type associated with the `StorageKey`.
    associatedtype Value = Self
}


/// Type erasure for `Storage.Value`
private protocol AnyStorageValue {
    var anyValue: Any { get }
    
    func shutdown(logger: Logger)
}


/// A typesafe storage of arbitrary key value information
actor Storage {
    private struct Value<T>: AnyStorageValue {
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
    
    
    private var storage: [ObjectIdentifier: AnyStorageValue]
    private let logger: Logger
    
    
    /// Initialize a `Storage` instance.
    /// - Parameter logger: A logger used to log events in the `Storage` instance.
    init(logger: Logger = Logger(subsystem: "edu.stanford.cardinalkit.storage", category: "storage")) {
        self.storage = [:]
        self.logger = logger
    }
    
    
    /// Clear the `Storage` instance.
    func clear() {
        self.storage = [:]
    }

    /// Check if  the `Storage` instance contains a key.
    /// - Parameter key: The metatype used as a key in the `Storage` instance.
    /// - Returns: `true` of the `Storage` instance contains a value for the `key`. `false` if there is no value present.
    func contains<Key>(_ key: Key.Type) -> Bool {
        self.storage.keys.contains(ObjectIdentifier(Key.self))
    }

    /// Get the value corresponding to a key.
    /// - Parameter key: The metatype used as a key in the `Storage` instance.
    /// - Returns: The value for the `key` stored in the `Storage` instance.
    func get<Key: StorageKey>(_ key: Key.Type) -> Key.Value? {
        guard let value = self.storage[ObjectIdentifier(Key.self)] as? Value<Key.Value> else {
            return nil
        }
        return value.value
    }
    
    /// Get the value corresponding to a key or stores and returns a value defined by the passed in default value.
    /// - Parameter key: The metatype used as a key in the `Storage` instance.
    /// - Returns: The value for the `key` stored in the `Storage` instance or the value defined by the passed in default value.
    func get<Key: StorageKey>(_ key: Key.Type, default defaultValue: @autoclosure () -> Key.Value) -> Key.Value {
        guard let value = self.storage[ObjectIdentifier(Key.self)] as? Value<Key.Value> else {
            set(key, to: defaultValue())
            return get(key, default: defaultValue())
        }
        return value.value
    }
    
    /// Get all values in the `Storage` instance that conform to a specific type.
    /// - Parameter allThatConformTo: The type that the returned instances should conform to.
    /// - Returns: Returns an `Array` of all types in the `Storage` instance conforming to the specified type.
    func get<Key>(allThatConformTo: Key.Type) -> [Key] {
        storage.values.compactMap { $0.anyValue as? Key }
    }

    /// Set a value for a key in the `Storage` instance.
    /// - Parameters:
    ///   - key: he metatype used as a key in the `Storage` instance.
    ///   - value: The value that will be stored for the `key` stored in the `Storage` instance.
    ///   - onShutdown: An optional closure that is called when the `Storage` is shut down.
    func set<Key: StorageKey>(
        _ key: Key.Type,
        to value: Key.Value?,
        onShutdown: ((Key.Value) throws -> Void)? = nil
    ) {
        let key = ObjectIdentifier(Key.self)
        
        if let existing = self.storage[key] {
            self.storage[key] = nil
            existing.shutdown(logger: self.logger)
        }
        
        if let value = value {
            self.storage[key] = Value(value: value, onShutdown: onShutdown)
        } else {
            self.storage[key] = nil
        }
    }

    /// Call the shutdown closure for every stored element
    func shutdown() {
        self.storage.values.forEach {
            $0.shutdown(logger: self.logger)
        }
    }
}
