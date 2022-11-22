//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension UsernamePasswordLoginView {
    public struct Localization: Codable {
        public let navigationTitle: String
        public let usernameTitle: String
        public let passwordTitle: String
        public let passwordRepeatTitle: String
        public let usernamePlaceholder: String
        public let passwordPlaceholder: String
        public let passwordRepeatPlaceholder: String
        public let passwordRepeatNotEqual: String
        public let loginButtonTitle: String
        
        
        var usernamePasswordFieldsLocalization: UsernamePasswordFields.Localization {
            UsernamePasswordFields.Localization(
                usernameTitle: usernameTitle,
                passwordTitle: passwordTitle,
                passwordRepeatTitle: passwordRepeatTitle,
                usernamePlaceholder: usernamePlaceholder,
                passwordPlaceholder: passwordPlaceholder,
                passwordRepeatPlaceholder: passwordRepeatPlaceholder,
                passwordRepeatNotEqual: passwordRepeatNotEqual
            )
        }
        
        public static let `default` = Localization(
            navigationTitle: String(localized: "LOGIN_UAP_NAVIGATION_TITLE", bundle: .module),
            usernameTitle: UsernamePasswordFields.Localization.default.usernameTitle,
            passwordTitle: UsernamePasswordFields.Localization.default.passwordTitle,
            passwordRepeatTitle: UsernamePasswordFields.Localization.default.passwordRepeatTitle,
            usernamePlaceholder: UsernamePasswordFields.Localization.default.usernamePlaceholder,
            passwordPlaceholder: UsernamePasswordFields.Localization.default.passwordPlaceholder,
            passwordRepeatPlaceholder: UsernamePasswordFields.Localization.default.passwordRepeatPlaceholder,
            passwordRepeatNotEqual: UsernamePasswordFields.Localization.default.passwordRepeatNotEqual,
            loginButtonTitle: String(localized: "LOGIN_UAP_LOGIN_BUTTON_TITLE", bundle: .module)
        )
        
        
        public init(
            navigationTitle: String = `default`.navigationTitle,
            usernameTitle: String = `default`.usernameTitle,
            passwordTitle: String = `default`.passwordTitle,
            passwordRepeatTitle: String = `default`.passwordRepeatTitle,
            usernamePlaceholder: String = `default`.usernamePlaceholder,
            passwordPlaceholder: String = `default`.passwordPlaceholder,
            passwordRepeatPlaceholder: String = `default`.passwordRepeatPlaceholder,
            passwordRepeatNotEqual: String = `default`.passwordRepeatNotEqual,
            loginButtonTitle: String = `default`.loginButtonTitle
        ) {
            self.navigationTitle = navigationTitle
            self.usernameTitle = usernameTitle
            self.passwordTitle = passwordTitle
            self.passwordRepeatTitle = passwordRepeatTitle
            self.usernamePlaceholder = usernamePlaceholder
            self.passwordPlaceholder = passwordPlaceholder
            self.passwordRepeatPlaceholder = passwordRepeatPlaceholder
            self.passwordRepeatNotEqual = passwordRepeatNotEqual
            self.loginButtonTitle = loginButtonTitle
        }
    }
}
