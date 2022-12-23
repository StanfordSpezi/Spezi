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
    public struct Login: Codable {
        /// <#Description#>
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
        
        
        /// <#Description#>
        public let buttonTitle: String
        /// <#Description#>
        public let navigationTitle: String
        /// <#Description#>
        public let username: FieldLocalization
        /// <#Description#>
        public let password: FieldLocalization
        /// <#Description#>
        public let loginActionButtonTitle: String
        /// <#Description#>
        public let defaultLoginFailedError: String
        
        
        /// <#Description#>
        /// - Parameters:
        ///   - buttonTitle: <#buttonTitle description#>
        ///   - navigationTitle: <#navigationTitle description#>
        ///   - username: <#username description#>
        ///   - password: <#password description#>
        ///   - loginActionButtonTitle: <#loginActionButtonTitle description#>
        ///   - defaultLoginFailedError: <#defaultLoginFailedError description#>
        public init(
            buttonTitle: String = Login.default.buttonTitle,
            navigationTitle: String = Login.default.navigationTitle,
            username: FieldLocalization = Login.default.username,
            password: FieldLocalization = Login.default.password,
            loginActionButtonTitle: String = Login.default.loginActionButtonTitle,
            defaultLoginFailedError: String = Login.default.defaultLoginFailedError
        ) {
            self.buttonTitle = buttonTitle.localized
            self.navigationTitle = navigationTitle.localized
            self.username = username
            self.password = password
            self.loginActionButtonTitle = loginActionButtonTitle.localized
            self.defaultLoginFailedError = defaultLoginFailedError.localized
        }
    }
}
