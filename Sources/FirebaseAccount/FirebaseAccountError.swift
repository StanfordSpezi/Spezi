//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import Foundation


enum FirebaseAccountError: LocalizedError {
    case invalidEmail
    case accountAlreadyInUse
    case weakPassword
    case setupError
    case unknown(AuthErrorCode.Code)
    
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "FIREBASE_ACCOUNT_ERROR_INVALID_EMAIL"
        case .accountAlreadyInUse:
            return "FIREBASE_ACCOUNT_ALREADY_IN_USE"
        case .weakPassword:
            return "FIREBASE_ACCOUNT_WEAK_PASSWORD"
        case .setupError:
            return "FIREBASE_ACCOUNT_SETUP_ERROR"
        case .unknown:
            return "FIREBASE_ACCOUNT_UNKNOWN"
        }
    }
    
    var failureReason: String? {
        errorDescription
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidEmail:
            return "FIREBASE_ACCOUNT_ERROR_INVALID_EMAIL_SUGGESTION"
        case .accountAlreadyInUse:
            return "FIREBASE_ACCOUNT_ALREADY_IN_USE_SUGGESTION"
        case .weakPassword:
            return "FIREBASE_ACCOUNT_WEAK_PASSWORD_SUGGESTION"
        case .setupError:
            return "FIREBASE_ACCOUNT_SETUP_ERROR_SUGGESTION"
        case .unknown:
            return "FIREBASE_ACCOUNT_UNKNOWN_SUGGESTION"
        }
    }
    
    
    init(authErrorCode: AuthErrorCode) {
        switch authErrorCode.code {
        case .invalidEmail:
            self = .invalidEmail
        case .emailAlreadyInUse:
            self = .accountAlreadyInUse
        case .weakPassword:
            self = .weakPassword
        case .operationNotAllowed, .invalidAPIKey, .appNotAuthorized, .keychainError, .internalError:
            self = .setupError
        default:
            self = .unknown(authErrorCode.code)
        }
    }
}
