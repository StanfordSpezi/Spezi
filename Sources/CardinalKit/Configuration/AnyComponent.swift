//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Type-erased version of a ``Component`` used internally in CardinalKit.
///
/// Due to Swift constraints, this type needs to be public.
/// The underscore before the type indicates to documentation builders to ignore the type and auto-completion in, e.g., Xcode to not suggest the type.
public protocol _AnyComponent {
    /// Type-erased version of ``Component/configure(cardinalKit:)``.
    ///
    /// - Parameter cardinalKit: A type-erased ``CardinalKit`` instance.
    func _configureAny(cardinalKit: Any) // swiftlint:disable:this identifier_name
    // We want the visit function to be hidden from autocompletion and document generation. Therefore, we use the `_` prefix.
}


extension Array where Element == _AnyComponent {
    // We want the visit function to be hidden from autocompletion and document generation. Therefore, we use the `_` prefix.
    // swiftlint:disable:next identifier_name
    func _configureAny(cardinalKit: Any) {
        forEach {
            $0._configureAny(cardinalKit: cardinalKit)
        }
    }
}
