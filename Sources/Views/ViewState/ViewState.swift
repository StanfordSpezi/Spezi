//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// <#Description#>
public enum ViewState: Equatable {
    /// <#Description#>
    case idle
    /// <#Description#>
    case processing
    /// <#Description#>
    case error(LocalizedError)
    
    
    /// <#Description#>
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
    
    /// <#Description#>
    public var errorDescription: String {
        switch self {
        case let .error(error):
            var errorDescription = ""
            if let failureReason = error.failureReason {
                errorDescription.append("\(failureReason)\n\n")
            }
            if let helpAnchor = error.helpAnchor {
                errorDescription.append("\(helpAnchor)\n\n")
            }
            if let recoverySuggestion = error.recoverySuggestion {
                errorDescription.append("\(recoverySuggestion)\n\n")
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
