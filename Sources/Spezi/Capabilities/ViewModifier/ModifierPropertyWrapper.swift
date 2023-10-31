//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

// TODO: review documentation!


@propertyWrapper
public class _ModifierPropertyWrapper<Modifier: ViewModifier> {
    // swiftlint:disable:previous type_name
    // We want the type to be hidden from autocompletion and documentation generation

    private var storedValue: Modifier
    private var collected = false


    public var wrappedValue: Modifier {
        get {
            storedValue
        }
        set {
            precondition(!collected, "You cannot update a @Modifier property after it was already collected.")
            storedValue = newValue
        }
    }


    public init(wrappedValue: Modifier) {
        self.storedValue = wrappedValue
    }
}


extension Component {
    public typealias ViewModifier = _ModifierPropertyWrapper
}


extension _ModifierPropertyWrapper: ViewModifierProvider {
    var viewModifier: any ViewModifier {
        collected = true
        return storedValue
    }
}
