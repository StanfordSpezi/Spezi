//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Refer to the documentation of ``Module/Application``.
@propertyWrapper
public class _ApplicationPropertyWrapper<Value> { // swiftlint:disable:this type_name
    private let keyPath: KeyPath<Spezi, Value>

    private weak var spezi: Spezi?
    /// Some KeyPaths are declared to copy the value upon injection and not query them every time.
    private var shadowCopy: Value?


    /// Access the application property.
    public var wrappedValue: Value {
        if let shadowCopy {
            return shadowCopy
        }

        guard let spezi else {
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
        self.spezi = spezi
        if spezi.createsCopy(keyPath) {
            self.shadowCopy = spezi[keyPath: keyPath]
        }
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
