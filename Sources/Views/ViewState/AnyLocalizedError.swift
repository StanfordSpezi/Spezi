//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// A type erased version of `LocalizedError` with convenience initializers to do a best-effort transform an exsting `Error` to an `LocalizedError`.
public struct AnyLocalizedError: LocalizedError {
    /// <#Description#>
    public var errorDescription: String?
    /// <#Description#>
    public var failureReason: String?
    /// <#Description#>
    public var helpAnchor: String?
    /// <#Description#>
    public var recoverySuggestion: String?
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - error: <#error description#>
    ///   - defaultErrorDescription: <#defaultErrorDescription description#>
    public init(error: Error, defaultErrorDescription: String) {
        switch error {
        case let localizedError as LocalizedError:
            self.errorDescription = localizedError.errorDescription ?? defaultErrorDescription
            self.failureReason = localizedError.failureReason
            self.helpAnchor = localizedError.helpAnchor
            self.recoverySuggestion = localizedError.recoverySuggestion
        case let customStringConvertible as CustomStringConvertible:
            self.errorDescription = customStringConvertible.description
        default:
            self.errorDescription = defaultErrorDescription
        }
    }
}
