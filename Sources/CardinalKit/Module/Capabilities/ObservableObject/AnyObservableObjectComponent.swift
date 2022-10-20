//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Type-erased version of a ``ObservableObjectComponent`` used internally in CardinalKit.
///
/// Due to Swift constraints, this type needs to be public.
/// The underscore before the type indicates to documentation builders to ignore the type and auto-completion in, e.g., Xcode to not suggest the type.
public protocol _AnyObservableObjectComponent {
    /// The ``ViewModifier`` used to inject the ``ObservableObject`` in the SwiftUI view hierachy.
    var viewModifier: any ViewModifier { get }
}
