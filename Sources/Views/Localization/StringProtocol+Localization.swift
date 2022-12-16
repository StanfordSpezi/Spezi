//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension StringProtocol {
    /// Creates a localized verion of the instance conforming to `StringProtocol`.
    ///
    /// String literals (`StringLiteralType`) and `String.LocalizationValue` instances are tried to be localized using the main bundle.
    /// `String` instances are not localized. You have to manually localize a `String` instance using `String(localized:)`.
    public var localized: String {
        localized(nil)
    }
    
    
    /// Creates a localized verion of the instance conforming to `StringProtocol`.
    ///
    /// String literals (`StringLiteralType`) and `String.LocalizationValue` instances are tried to be localized using the provided bundle.
    /// `String` instances are not localized. You have to manually localize a `String` instance using `String(localized:)`.
    public func localized(_ bundle: Bundle?) -> String {
        switch self {
        case let text as String.LocalizationValue:
            return String(localized: text, bundle: bundle)
        case let text as StringLiteralType:
            return String(localized: String.LocalizationValue(text), bundle: bundle)
        default:
            return String(self)
        }
    }
}
