//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``DataChange`` tracks the addition or removal of elements across components.
///
/// ``DataChange`` instances are used in ``DataSourceRegistry``s to identify incoming data. ``Adapter``s use them as the basis for the transform functions.
///
/// The ``DataChange/map(element:removalContext:)`` function provides a convenient way to transform one ``DataChange`` instance in an other ``DataChange`` instance:
/// ```swift
/// let element: DataChange<Int, Int> = .addition(42)
/// element.map(
///     element: {
///         String($0.id)
///     },
///     removalContext: {
///         String($0.id)
///     }
/// )
/// ```
public enum DataChange<
    Element: Identifiable & Sendable,
    RemovalContext: Identifiable & Sendable
>: Sendable where Element.ID: Sendable, Element.ID == RemovalContext.ID {
    /// A new element was added
    case addition(Element)
    /// An element was removed
    case removal(RemovalContext)
    
    
    /// The identifier of the `Element`.
    public var id: Element.ID {
        switch self {
        case let .addition(element):
            return element.id
        case let .removal(removalContext):
            return removalContext.id
        }
    }
    
    
    /// Maps a ``DataChange`` to an other `Element` type.
    /// - Parameters:
    ///   - elementMap: The element map function maps the complete `Element` instance used for the ``DataChange/addition(_:)`` case.
    ///   - idMap: The id map function only maps the identifier or an `Element` used for the ``DataChange/removal(_:)`` case.
    /// - Returns: Returns the mapped element
    public func map<E, R> (
        element elementMap: (Element) -> (E),
        removalContext removalContextMap: (RemovalContext) -> (R)
    ) -> DataChange<E, R> {
        switch self {
        case let .addition(element):
            return .addition(elementMap(element))
        case let .removal(removalContext):
            return .removal(removalContextMap(removalContext))
        }
    }
}
