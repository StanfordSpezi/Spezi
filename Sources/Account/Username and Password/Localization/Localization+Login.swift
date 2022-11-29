//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Localization {
    public struct Login: Codable {
        public static let `default` = Login(
            buttonTitle: String(moduleLocalized: "UAP_LOGIN_BUTTON_TITLE"),
            navigationTitle: String(moduleLocalized: "UAP_LOGIN_NAVIGATION_TITLE"),
            username: Localization.Field(
                title: String(moduleLocalized: "UAP_LOGIN_USERNAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_LOGIN_USERNAME_PLACEHOLDER")
            ),
            password: Localization.Field(
                title: String(moduleLocalized: "UAP_LOGIN_PASSWORD_TITLE"),
                placeholder: String(moduleLocalized: "UAP_LOGIN_PASSWORD_PLACEHOLDER")
            ),
            loginActionButtonTitle: String(moduleLocalized: "UAP_LOGIN_ACTION_BUTTON_TITLE")
        )
        
        
        public let buttonTitle: String
        public let navigationTitle: String
        public let username: Field
        public let password: Field
        public let loginActionButtonTitle: String
        
        
        init(
            buttonTitle: String = Login.default.buttonTitle,
            navigationTitle: String = Login.default.navigationTitle,
            username: Field = Login.default.username,
            password: Field = Login.default.password,
            loginActionButtonTitle: String = Login.default.loginActionButtonTitle
        ) {
            self.buttonTitle = buttonTitle
            self.navigationTitle = navigationTitle
            self.username = username
            self.password = password
            self.loginActionButtonTitle = loginActionButtonTitle
        }
    }
}
