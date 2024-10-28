//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Access a property or action of the Spezi application.
@propertyWrapper
public struct _ApplicationPropertyWrapper<Value> { // swiftlint:disable:this type_name
    private final class State {
        weak var spezi: Spezi?
        /// Some KeyPaths are declared to copy the value upon injection and not query them every time.
        var shadowCopy: Value?
    }

    private let keyPath: KeyPath<Spezi, Value>
    private let state = State()


    /// Access the application property.
    public var wrappedValue: Value {
        if let shadowCopy = state.shadowCopy {
            return shadowCopy
        }

        guard let spezi = state.spezi else {
            preconditionFailure("Underlying Spezi instance was not yet injected. @Application cannot be accessed within the initializer!")
        }
        return spezi[keyPath: keyPath]
    }

    /// Initialize a new `@Application` property wrapper
    /// - Parameter keyPath: The property to access.
    public init(_ keyPath: KeyPath<Spezi, Value>) {
        self.keyPath = keyPath
    }
}


extension _ApplicationPropertyWrapper: SpeziPropertyWrapper {
    func inject(spezi: Spezi) {
        state.spezi = spezi
        if spezi.createsCopy(keyPath) {
            state.shadowCopy = spezi[keyPath: keyPath]
        }
    }

    func clear() {
        state.spezi = nil
        state.shadowCopy = nil
    }
}


extension Module {
    /// Access a property or action of the application.
    ///
    /// The `@Application` property wrapper can be used inside your `Module` to
    /// access a property or action of your application.
    ///
    /// - Note: You can access the contents of `@Application` once your ``Module/configure()-5pa83`` method is called
    ///     (e.g., it must not be used in the `init`).
    ///
    /// Below is a short code example:
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Application(\.logger)
    ///     var logger
    ///
    ///     func configure() {
    ///         logger.info("Module is being configured ...")
    ///     }
    /// }
    /// ```
    public typealias Application<Value> = _ApplicationPropertyWrapper<Value>
}
