//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


@MainActor
enum DynamicReference<Element: AnyObject>: Sendable {
    struct WeaklyStoredElement {
        private(set) nonisolated(unsafe) weak var element: Element?

        init(_ element: Element? = nil) {
            self.element = element
        }
    }

    case element(Element)
    case weakElement(WeaklyStoredElement)

    static func weakElement(_ element: Element) -> DynamicReference<Element> {
        .weakElement(WeaklyStoredElement(element))
    }

    nonisolated var element: Element? {
        switch self {
        case let .element(element):
            return element
        case let .weakElement(reference):
            return reference.element
        }
    }
}
