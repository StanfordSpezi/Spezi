//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// The ``ViewState`` allows SwiftUI views to keep track of their state and possible communicate it to outside views, e.g., using `Binding`s.
public enum ViewState: Equatable {
    /// The view is idle and displaying content.
    case idle
    /// The view is in a processing state, e.g. loading content.
    case processing
    /// The view is in an error state, e.g., loading the content failed.
    case error(LocalizedError)
    
    
    /// The localized error title of the view if it is in an error state. An empty string if it is in an non-error state.
    public var errorTitle: String {
        switch self {
        case let .error(error):
            guard let errorTitle = error.errorDescription else {
                fallthrough
            }
            return errorTitle
        default:
            return String(localized: "VIEW_STATE_DEFAULT_ERROR_TITLE", bundle: .module)
        }
    }
    
    /// The localized error description of the view if it is in an error state. An empty string if it is in an non-error state.
    public var errorDescription: String {
        switch self {
        case let .error(error):
            var errorDescription = ""
            if let failureReason = error.failureReason {
                errorDescription.append("\(failureReason)")
            }
            if let helpAnchor = error.helpAnchor {
                errorDescription.append("\(errorDescription.isEmpty ? "" : "\n\n")\(helpAnchor)")
            }
            if let recoverySuggestion = error.recoverySuggestion {
                errorDescription.append("\(errorDescription.isEmpty ? "" : "\n\n")\(recoverySuggestion)")
            }
            if errorDescription.isEmpty {
                errorDescription = error.localizedDescription
            }
            return errorDescription
        default:
            return ""
        }
    }
    
    
    public static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.processing, .processing), (.error, .error):
            return true
        default:
            return false
        }
    }
}
