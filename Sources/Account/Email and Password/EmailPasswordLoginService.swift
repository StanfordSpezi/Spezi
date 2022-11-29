//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


class EmailPasswordLoginService: UsernamePasswordLoginService {
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
        let usernameField = Localization.Field(title: "EAP_LOGIN_USERNAME_TITLE", placeholder: "EAP_LOGIN_USERNAME_PLACEHOLDER")
        return Localization(
            login: .init(username: usernameField),
            signUp: .init(username: usernameField),
            resetPassword: .init(username: usernameField)
        )
    }
    
    override var loginButton: AnyView {
        AnyView(
            NavigationLink {
                UsernamePasswordLoginView(
                    usernameValidationRules: validationRules
                )
                    .environmentObject(self as UsernamePasswordLoginService)
            } label: {
                AccountServiceButton {
                    Image(systemName: "envelope.fill")
                        .font(.title2)
                    Text("EAP_BUTTON_TITLE", bundle: .module)
                }
            }
        )
    }
}
