//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Views


extension Localization {
    public struct ResetPassword: Codable {
        public static let `default` = ResetPassword(
            buttonTitle: String(moduleLocalized: "UAP_RESET_PASSWORD_BUTTON_TITLE"),
            navigationTitle: String(moduleLocalized: "UAP_RESET_PASSWORD_NAVIGATION_TITLE"),
            username: FieldLocalization(
                title: String(moduleLocalized: "UAP_RESET_PASSWORD_USERNAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_RESET_PASSWORD_USERNAME_PLACEHOLDER")
            ),
            resetPasswordActionbuttonTitle: String(moduleLocalized: "UAP_RESET_PASSWORD_ACTION_BUTTON_TITLE"),
            processSuccessfulLabel: String(moduleLocalized: "UAP_RESET_PASSWORD_PROCESS_SUCCESSFUL_LABEL"),
            defaultResetPasswordFailedError: String(moduleLocalized: "UAP_RESET_PASSWORD_FAILED_DEFAULT_ERROR")
        )
        
        
        public let buttonTitle: String
        public let navigationTitle: String
        public let username: FieldLocalization
        public let resetPasswordActionbuttonTitle: String
        public let processSuccessfulLabel: String
        public let defaultResetPasswordFailedError: String
        
        
        init(
            buttonTitle: String = ResetPassword.default.buttonTitle,
            navigationTitle: String = ResetPassword.default.navigationTitle,
            username: FieldLocalization = ResetPassword.default.username,
            resetPasswordActionbuttonTitle: String = ResetPassword.default.resetPasswordActionbuttonTitle,
            processSuccessfulLabel: String = ResetPassword.default.processSuccessfulLabel,
            defaultResetPasswordFailedError: String = ResetPassword.default.defaultResetPasswordFailedError
        ) {
            self.buttonTitle = buttonTitle
            self.navigationTitle = navigationTitle
            self.username = username
            self.resetPasswordActionbuttonTitle = resetPasswordActionbuttonTitle
            self.processSuccessfulLabel = processSuccessfulLabel
            self.defaultResetPasswordFailedError = defaultResetPasswordFailedError
        }
    }
}
