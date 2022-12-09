//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


enum AccountViewState: Equatable {
    case idle
    case processing
    case error(Error)
    
    
    var errorTitle: String {
        switch self {
        case let .error(error as LocalizedError):
            return error.errorDescription
            ?? String(localized: "LOGIN_UAP_DEFAULT_ERROR", bundle: .module)
        default:
            return String(localized: "LOGIN_UAP_DEFAULT_ERROR", bundle: .module)
        }
    }
    
    var errorDescription: String {
        switch self {
        case let .error(error as LocalizedError):
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
        case let .error(error):
            return error.localizedDescription
        default:
            return ""
        }
    }
    
    static func == (lhs: AccountViewState, rhs: AccountViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.processing, .processing), (.error, .error):
            return true
        default:
            return false
        }
    }
}
