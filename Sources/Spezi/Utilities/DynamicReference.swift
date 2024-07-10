//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


struct WeakReference<Element: AnyObject> {
    weak var value: Element?
}


enum DynamicReference<Element: AnyObject> {
    case strong(Element)
    case weak(WeakReference<Element>)

    var value: Element? {
        switch self {
        case let .strong(module):
            return module
        case let .weak(reference):
            return reference.value
        }
    }
}
