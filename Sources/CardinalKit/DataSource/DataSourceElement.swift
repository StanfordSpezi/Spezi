//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


public enum DataSourceElement<Element: Identifiable> {
    case addition(Element)
    case removal(Element.ID)
}
