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
                message: String(localized: "LOGIN_EAP_EMAIL_VERIFICATION_ERROR", bundle: .module)
            )
        ]
    }
    
    override var loginButton: AnyView {
        AnyView(
            NavigationLink {
                UsernamePasswordLoginView(
                    localization: UsernamePasswordLoginView.Localization(
                        usernameTitle: String(localized: "LOGIN_EAP_USERNAME_TITLE", bundle: .module),
                        usernamePlaceholder: String(localized: "LOGIN_EAP_USERNAME_PLACEHOLDER", bundle: .module)
                    ),
                    usernameValidationRules: validationRules
                )
                    .environmentObject(self as UsernamePasswordLoginService)
            } label: {
                PrimaryActionButton {
                    Image(systemName: "envelope.fill")
                        .font(.title2)
                    Text("LOGIN_EAP_BUTTON_TITLE", bundle: .module)
                }
            }
        )
    }
}
