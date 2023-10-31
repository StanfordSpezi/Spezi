//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Refer to the documentation of ``Module/Model``.
@propertyWrapper
public class _ModelPropertyWrapper<Model: Observable & AnyObject> {
    // swiftlint:disable:previous type_name
    // We want the type to be hidden from autocompletion and documentation generation

    private var storedValue: Model
    private var collected = false


    /// Access the store model.
    /// - Note: You cannot access the value once it was collected.
    public var wrappedValue: Model {
        get {
            storedValue
        }
        set {
            precondition(!collected, "You cannot reassign a @Model property after it was already collected.")
            storedValue = newValue
        }
    }


    /// Initialize a new `@Model` property wrapper.
    /// - Parameter wrappedValue: The initial value.
    public init(wrappedValue: Model) {
        self.storedValue = wrappedValue
    }
}


extension Module {
    /// Places an observable object in the global view environment.
    ///
    /// The `@Model` property wrapper can be used inside your `Module` to place an
    /// observable model type into the global SwiftUI view environment.
    ///
    /// Below is a short code example:
    /// ```swift
    /// @Observable
    /// class ExampleModel {
    ///     var someState: Bool = false
    ///
    ///     init() {}
    /// }
    ///
    /// class ExampleModule: Module {
    ///     @Model var model = ExampleModel()
    /// }
    /// ```
    ///
    /// - Note: It is guaranteed that all observable objects placed into the environment using `@Model`
    ///     are available in all `ViewModifier`s created using the `@Modifier` property wrapper.
    public typealias Model = _ModelPropertyWrapper
}


extension _ModelPropertyWrapper: ViewModifierProvider {
    var viewModifier: any ViewModifier {
        collected = true
        return ModelModifier(model: storedValue)
    }

    var placement: ModifierPlacement {
        .outermost
    }
}
