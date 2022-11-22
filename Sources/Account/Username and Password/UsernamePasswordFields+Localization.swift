//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension UsernamePasswordFields {
    public struct Localization: Codable {
        public let usernameTitle: String
        public let passwordTitle: String
        public let passwordRepeatTitle: String
        public let usernamePlaceholder: String
        public let passwordPlaceholder: String
        public let passwordRepeatPlaceholder: String
        public let passwordRepeatNotEqual: String
        
        
        public static let `default` = Localization(
            usernameTitle: String(localized: "LOGIN_UAP_USERNAME_TITLE", bundle: .module),
            passwordTitle: String(localized: "LOGIN_UAP_PASSWORD_TITLE", bundle: .module),
            passwordRepeatTitle: String(localized: "LOGIN_UAP_PASSWORD_REPEAT_TITLE", bundle: .module),
            usernamePlaceholder: String(localized: "LOGIN_UAP_USERNAME_PLACEHOLDER", bundle: .module),
            passwordPlaceholder: String(localized: "LOGIN_UAP_PASSWORD_PLACEHOLDER", bundle: .module),
            passwordRepeatPlaceholder: String(localized: "LOGIN_UAP_PASSWORD_REPEAT_PLACEHOLDER", bundle: .module),
            passwordRepeatNotEqual: String(localized: "LOGIN_UAP_PASSWORD_REPEAT_NOT_EQUAL", bundle: .module)
        )
        
        
        public init(
            usernameTitle: String = `default`.usernameTitle,
            passwordTitle: String = `default`.passwordTitle,
            passwordRepeatTitle: String = `default`.passwordRepeatTitle,
            usernamePlaceholder: String = `default`.usernamePlaceholder,
            passwordPlaceholder: String = `default`.passwordPlaceholder,
            passwordRepeatPlaceholder: String = `default`.passwordRepeatPlaceholder,
            passwordRepeatNotEqual: String = `default`.passwordRepeatNotEqual
        ) {
            self.usernameTitle = usernameTitle
            self.passwordTitle = passwordTitle
            self.passwordRepeatTitle = passwordRepeatTitle
            self.usernamePlaceholder = usernamePlaceholder
            self.passwordPlaceholder = passwordPlaceholder
            self.passwordRepeatPlaceholder = passwordRepeatPlaceholder
            self.passwordRepeatNotEqual = passwordRepeatNotEqual
        }
    }
}
