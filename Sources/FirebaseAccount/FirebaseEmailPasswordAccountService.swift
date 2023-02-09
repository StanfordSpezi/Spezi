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
    override var signUpButton: AnyView {
        button(
            localization.login.buttonTitle,
            destination: UsernamePasswordSignUpView(
                signUpOptions: [.usernameAndPassword, .name],
                usernameValidationRules: [emailValidationRule]
            )
        )
    }
    
    
    override init() {
        super.init()
    }
    
    
    override func login(username: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: username, password: password)
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
