//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension StringProtocol {
    /// <#Description#>
    public var localized: String {
        localized(nil)
    }
    
    
    /// <#Description#>
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
