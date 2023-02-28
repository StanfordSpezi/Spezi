//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Account
import FirebaseAuth
import SwiftUI


class FirebaseEmailPasswordAccountService: EmailPasswordAccountService {
    static var defaultPasswordValidationRule: ValidationRule {
        guard let regex = try? Regex(#"[^\s]{8,}"#) else {
            fatalError("Invalid Password Regex in the FirebaseEmailPasswordAccountService")
        }
        
        return ValidationRule(
            regex: regex,
            message: String(localized: "FIREBASE_ACCOUNT_DEFAULT_PASSWORD_RULE_ERROR", bundle: .module)
        )
    }
    
    
    private var passwordValidationRule: ValidationRule
    
    
    override var loginButton: AnyView {
        button(
            localization.login.buttonTitle,
            destination: UsernamePasswordLoginView(
                usernameValidationRules: [emailValidationRule],
                passwordValidationRules: [passwordValidationRule]
            )
        )
    }
    
    override var signUpButton: AnyView {
        button(
            localization.signUp.buttonTitle,
            destination: UsernamePasswordSignUpView(
                signUpOptions: [.usernameAndPassword, .name],
                usernameValidationRules: [emailValidationRule],
                passwordValidationRules: [passwordValidationRule]
            )
        )
    }
    
    
    init(passwordValidationRule: ValidationRule = FirebaseEmailPasswordAccountService.defaultPasswordValidationRule) {
        self.passwordValidationRule = passwordValidationRule
        super.init()
    }
    
    
    override func login(username: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: username, password: password)
            
            Task { @MainActor in
                account?.objectWillChange.send()
            }
        } catch let error as NSError {
            throw FirebaseAccountError(authErrorCode: AuthErrorCode(_nsError: error))
        } catch {
            throw FirebaseAccountError.unknown(.internalError)
        }
    }
    
    
    override func signUp(signUpValues: SignUpValues) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: signUpValues.username, password: signUpValues.password)
            
            let profileChangeRequest = authResult.user.createProfileChangeRequest()
            profileChangeRequest.displayName = signUpValues.name.formatted(.name(style: .long))
            try await profileChangeRequest.commitChanges()
            Task { @MainActor in
                account?.objectWillChange.send()
            }
            
            try await authResult.user.sendEmailVerification()
        } catch let error as NSError {
            throw FirebaseAccountError(authErrorCode: AuthErrorCode(_nsError: error))
        } catch {
            throw FirebaseAccountError.unknown(.internalError)
        }
    }
    
    override func resetPassword(username: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: username)
        } catch let error as NSError {
            throw FirebaseAccountError(authErrorCode: AuthErrorCode(_nsError: error))
        } catch {
            throw FirebaseAccountError.unknown(.internalError)
        }
    }
}
