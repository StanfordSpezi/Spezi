//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension StringProtocol {
    public var localized: String {
        switch self {
        case let text as String.LocalizationValue:
            return String(localized: text)
        case let text as StringLiteralType:
            return String(localized: String.LocalizationValue(text))
        case let text as String:
            return String(localized: String.LocalizationValue(text))
        default:
            return String(localized: String.LocalizationValue(String(self)))
        }
    }
}
