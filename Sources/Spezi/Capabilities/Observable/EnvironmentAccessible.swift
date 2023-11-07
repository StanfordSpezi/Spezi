//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Places a ``Module`` into the SwiftUI environment.
///
/// Below is a short code example how you would declare an environment accessible module,
/// and how to access it within SwiftUI, if it is configured in your ``Configuration``.
///
/// ```swift
/// public class ExampleModule: Module, EnvironmentAccessible {
///     // ... implement your functionality
/// }
///
///
/// struct ExampleView: View {
///     @Environment(ExampleModule.self) var module
///
///     var body: some View {
///         // ... access module functionality
///     }
/// }
/// ```
public protocol EnvironmentAccessible: AnyObject, Observable {}


extension EnvironmentAccessible {
    var viewModifier: any ViewModifier {
        ModelModifier(model: self)
    }
}
