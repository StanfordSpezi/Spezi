//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Refer to the documentation of ``Component/Modifier``.
@propertyWrapper
public class _ModifierPropertyWrapper<Modifier: ViewModifier> {
    // swiftlint:disable:previous type_name
    // We want the type to be hidden from autocompletion and documentation generation

    private var storedValue: Modifier
    private var collected = false


    /// Access the store value.
    /// - Note: You cannot access the value once it was collected.
    public var wrappedValue: Modifier {
        get {
            storedValue
        }
        set {
            precondition(!collected, "You cannot update a @Modifier property after it was already collected.")
            storedValue = newValue
        }
    }


    /// Initialize a new `@Modifier` property wrapper.
    /// - Parameter wrappedValue: The initial value.
    public init(wrappedValue: Modifier) {
        self.storedValue = wrappedValue
    }
}


extension Component {
    /// Provide a SwiftUI `ViewModifier` to modify the global view hierarchy.
    ///
    /// The `@Modifier` property wrapper can be used inside your `Component` to modify
    /// the global SwiftUI view hierarchy using the provided `ViewModifier` implementation.
    ///
    /// Below is a short code example that demonstrates the usage of a ViewModifier to set a global
    /// environment key.
    ///
    /// ```swift
    /// struct MyModifier: ViewModifier {
    ///     func body(content: Content) -> some View {
    ///         content
    ///             .environment(\.exampleKey, /* your configuration value */)
    ///     }
    /// }
    ///
    /// class MyComponent: Component {
    ///     @Modifier var modifier = MyModifier()
    /// }
    /// ```
    ///
    /// - Important: The value of the property must not be modified after the call to your ``Component/configure()``
    ///     method returned.
    public typealias Modifier = _ModifierPropertyWrapper
}


extension _ModifierPropertyWrapper: ViewModifierProvider {
    var viewModifier: any ViewModifier {
        collected = true
        return storedValue
    }
}
