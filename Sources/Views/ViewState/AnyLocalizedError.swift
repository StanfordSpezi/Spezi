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
    /// A localized message describing what error occurred.
    public var errorDescription: String?
    /// A localized message describing the reason for the failure.
    public var failureReason: String?
    /// A localized message describing how one might recover from the failure.
    public var helpAnchor: String?
    /// A localized message providing "help" text if the user requests help.
    public var recoverySuggestion: String?
    
    
    /// Provides a best-effort approach to create a type erased version of `LocalizedError`.
    /// - Parameters:
    ///   - error: The error instance that should be wrapped.
    ///   - defaultErrorDescription: The localized default error description that should be used if the `error` does not provide any context to create an error description.
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
