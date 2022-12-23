//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Views


extension Localization {
    /// <#Description#>
    public struct ResetPassword: Codable {
        /// <#Description#>
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
        
        
        /// <#Description#>
        public let buttonTitle: String
        /// <#Description#>
        public let navigationTitle: String
        /// <#Description#>
        public let username: FieldLocalization
        /// <#Description#>
        public let resetPasswordActionbuttonTitle: String
        /// <#Description#>
        public let processSuccessfulLabel: String
        /// <#Description#>
        public let defaultResetPasswordFailedError: String
        
        
        /// <#Description#>
        /// - Parameters:
        ///   - buttonTitle: <#buttonTitle description#>
        ///   - navigationTitle: <#navigationTitle description#>
        ///   - username: <#username description#>
        ///   - resetPasswordActionbuttonTitle: <#resetPasswordActionbuttonTitle description#>
        ///   - processSuccessfulLabel: <#processSuccessfulLabel description#>
        ///   - defaultResetPasswordFailedError: <#defaultResetPasswordFailedError description#>
        public init(
            buttonTitle: String = ResetPassword.default.buttonTitle,
            navigationTitle: String = ResetPassword.default.navigationTitle,
            username: FieldLocalization = ResetPassword.default.username,
            resetPasswordActionbuttonTitle: String = ResetPassword.default.resetPasswordActionbuttonTitle,
            processSuccessfulLabel: String = ResetPassword.default.processSuccessfulLabel,
            defaultResetPasswordFailedError: String = ResetPassword.default.defaultResetPasswordFailedError
        ) {
            self.buttonTitle = buttonTitle.localized
            self.navigationTitle = navigationTitle.localized
            self.username = username
            self.resetPasswordActionbuttonTitle = resetPasswordActionbuttonTitle.localized
            self.processSuccessfulLabel = processSuccessfulLabel.localized
            self.defaultResetPasswordFailedError = defaultResetPasswordFailedError.localized
        }
    }
}
