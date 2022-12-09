//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


enum MockAccountServiceError: LocalizedError {
    case usernameTaken
    case wrongCredentials
    
    
    var errorDescription: String? {
        switch self {
        case .usernameTaken:
            return "Username is already taken"
        case .wrongCredentials:
            return "Credentials do not match"
        }
    }
    
    var failureReason: String? {
        errorDescription
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .usernameTaken:
            return "Please provide a different username."
        case .wrongCredentials:
            return "Please ensure that the entered credentials are correct."
        }
    }
}
