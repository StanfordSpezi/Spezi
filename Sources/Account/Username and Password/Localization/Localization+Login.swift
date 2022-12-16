//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Views


extension Localization {
    public struct Login: Codable {
        public static let `default` = Login(
            buttonTitle: String(moduleLocalized: "UAP_LOGIN_BUTTON_TITLE"),
            navigationTitle: String(moduleLocalized: "UAP_LOGIN_NAVIGATION_TITLE"),
            username: FieldLocalization(
                title: String(moduleLocalized: "UAP_LOGIN_USERNAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_LOGIN_USERNAME_PLACEHOLDER")
            ),
            password: FieldLocalization(
                title: String(moduleLocalized: "UAP_LOGIN_PASSWORD_TITLE"),
                placeholder: String(moduleLocalized: "UAP_LOGIN_PASSWORD_PLACEHOLDER")
            ),
            loginActionButtonTitle: String(moduleLocalized: "UAP_LOGIN_ACTION_BUTTON_TITLE"),
            defaultLoginFailedError: String(moduleLocalized: "UAP_LOGIN_FAILED_DEFAULT_ERROR")
        )
        
        
        public let buttonTitle: String
        public let navigationTitle: String
        public let username: FieldLocalization
        public let password: FieldLocalization
        public let loginActionButtonTitle: String
        public let defaultLoginFailedError: String
        
        
        init(
            buttonTitle: String = Login.default.buttonTitle,
            navigationTitle: String = Login.default.navigationTitle,
            username: FieldLocalization = Login.default.username,
            password: FieldLocalization = Login.default.password,
            loginActionButtonTitle: String = Login.default.loginActionButtonTitle,
            defaultLoginFailedError: String = Login.default.defaultLoginFailedError
        ) {
            self.buttonTitle = buttonTitle
            self.navigationTitle = navigationTitle
            self.username = username
            self.password = password
            self.loginActionButtonTitle = loginActionButtonTitle
            self.defaultLoginFailedError = defaultLoginFailedError
        }
    }
}
