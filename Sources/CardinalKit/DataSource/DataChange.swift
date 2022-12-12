//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``DataChange`` tracks the addition or removel of elements across components.
public enum DataChange<Element: Identifiable & Sendable>: Sendable where Element.ID: Sendable {
    /// A new element was added
    case addition(Element)
    /// An element was removed
    case removal(Element.ID)
    
    
    /// The identifier of the `Element`.
    public var id: Element.ID {
        switch self {
        case let .addition(element):
            return element.id
        case let .removal(elementId):
            return elementId
        }
    }
    
    
    /// Maps a ``DataChange`` to an other `Element` type.
    /// - Parameters:
    ///   - elementMap: The element map function maps the complete `Element` instance used for the ``DataChange/addition(_:)`` case.
    ///   - idMap: The id map function only maps the identifier or an `Element` used for the ``DataChange/removal(_:)`` case.
    /// - Returns: Returns the mapped element
    public func map<I: Identifiable & Sendable>(
        element elementMap: (Element) -> I,
        id idMap: (Element.ID) -> I.ID
    ) -> DataChange<I> {
        switch self {
        case let .addition(element):
            return .addition(elementMap(element))
        case let .removal(elementId):
            return .removal(idMap(elementId))
        }
    }
}
