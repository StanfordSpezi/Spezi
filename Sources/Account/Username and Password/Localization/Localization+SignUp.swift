//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Localization {
    public struct ResetPassword: Codable {
        public static let `default` = ResetPassword(
            buttonTitle: String(moduleLocalized: "UAP_RESET_PASSWORD_BUTTON_TITLE"),
            navigationTitle: String(moduleLocalized: "UAP_RESET_PASSWORD_NAVIGATION_TITLE"),
            username: Localization.Field(
                title: String(moduleLocalized: "UAP_RESET_PASSWORD_USERNAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_RESET_PASSWORD_USERNAME_PLACEHOLDER")
            ),
            resetPasswordActionbuttonTitle: String(moduleLocalized: "UAP_RESET_PASSWORD_ACTION_BUTTON_TITLE")
        )
        
        
        public let buttonTitle: String
        public let navigationTitle: String
        public let username: Field
        public let resetPasswordActionbuttonTitle: String
        
        
        init(
            buttonTitle: String = ResetPassword.default.buttonTitle,
            navigationTitle: String = ResetPassword.default.navigationTitle,
            username: Field = ResetPassword.default.username,
            resetPasswordActionbuttonTitle: String = ResetPassword.default.resetPasswordActionbuttonTitle
        ) {
            self.buttonTitle = buttonTitle
            self.navigationTitle = navigationTitle
            self.username = username
            self.resetPasswordActionbuttonTitle = resetPasswordActionbuttonTitle
        }
    }
}
