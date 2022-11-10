//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``DataSourceElement`` enables ``DataSourceRegistry``s to keep track of incoming data.
/// Emit ``TypedAsyncSequence``s carrying ``DataSourceElement`` to transport data from a data source to a ``DataSourceRegistry``.
public enum DataSourceElement<Element: Identifiable> {
    /// A new element was added by the data source.
    case addition(Element)
    /// An element was removed by the data source.
    case removal(Element.ID)
    
    
    var id: Element.ID {
        switch self {
        case let .addition(element):
            return element.id
        case let .removal(elementId):
            return elementId
        }
    }
    
    
    func map<I: Identifiable>(
        element elementMap: (Element) -> I,
        id idMap: (Element.ID) -> I.ID
    ) -> DataSourceElement<I> {
        switch self {
        case let .addition(element):
            return .addition(elementMap(element))
        case let .removal(elementId):
            return .removal(idMap(elementId))
        }
    }
}
