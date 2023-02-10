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
            return ""
        case .accountAlreadyInUse:
            return ""
        case .weakPassword:
            return ""
        case .setupError:
            return ""
        case .unknown:
            return ""
        }
    }
    
    var failureReason: String? {
        errorDescription
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidEmail:
            return ""
        case .accountAlreadyInUse:
            return ""
        case .weakPassword:
            return ""
        case .setupError:
            return ""
        case .unknown:
            return ""
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
