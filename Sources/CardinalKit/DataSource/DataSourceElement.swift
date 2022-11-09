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
}
