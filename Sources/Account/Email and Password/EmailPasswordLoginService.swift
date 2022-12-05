//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


class EmailPasswordLoginService: UsernamePasswordAccountService {
    private var validationRules: [ValidationRule] {
        guard let regex = try? Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") else {
            return []
        }
        
        return [
            ValidationRule(
                regex: regex,
                message: String(localized: "EAP_EMAIL_VERIFICATION_ERROR", bundle: .module)
            )
        ]
    }
    
    override var localization: Localization {
        let usernameField = Localization.Field(
            title: String(moduleLocalized: "EAP_LOGIN_USERNAME_TITLE"),
            placeholder: String(moduleLocalized: "EAP_LOGIN_USERNAME_PLACEHOLDER")
        )
        return Localization(
            login: .init(buttonTitle: String(moduleLocalized: "EAP_LOGIN_BUTTON_TITLE"), username: usernameField),
            signUp: .init(buttonTitle: String(moduleLocalized: "EAP_SIGNUP_BUTTON_TITLE"), username: usernameField),
            resetPassword: .init(username: usernameField)
        )
    }
    
    override var loginButton: AnyView {
        button(
            localization.login.buttonTitle,
            destination: UsernamePasswordLoginView(
                usernameValidationRules: validationRules
            )
        )
    }
    
    override var signUpButton: AnyView {
        button(
            localization.login.buttonTitle,
            destination: UsernamePasswordSignUpView(
                usernameValidationRules: validationRules
            )
        )
    }
    
    
    override func button<V: View>(_ title: String, destination: V) -> AnyView {
        AnyView(
            NavigationLink {
                destination
                    .environmentObject(self as UsernamePasswordAccountService)
            } label: {
                AccountServiceButton {
                    Image(systemName: "envelope.fill")
                        .font(.title2)
                    Text(title)
                }
            }
        )
    }
}
