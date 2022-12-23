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
    public struct SignUp: Codable {
        /// <#Description#>
        public static let `default` = SignUp(
            buttonTitle: String(moduleLocalized: "UAP_SIGNUP_BUTTION_TITLE"),
            navigationTitle: String(moduleLocalized: "UAP_SIGNUP_NAVIGATION_TITLE"),
            username: FieldLocalization(
                title: String(moduleLocalized: "UAP_SIGNUP_USERNAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_USERNAME_PLACEHOLDER")
            ),
            password: FieldLocalization(
                title: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_PLACEHOLDER")
            ),
            passwordRepeat: FieldLocalization(
                title: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_REPEAT_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_REPEAT_PLACEHOLDER")
            ),
            passwordNotEqualError: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_NOT_EQUAL_ERROR"),
            givenName: FieldLocalization(
                title: String(moduleLocalized: "UAP_SIGNUP_GIVEN_NAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_GIVEN_NAME_PLACEHOLDER")
            ),
            familyName: FieldLocalization(
                title: String(moduleLocalized: "UAP_SIGNUP_FAMILY_NAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_FAMILY_NAME_PLACEHOLDER")
            ),
            genderIdentityTitle: String(moduleLocalized: "UAP_SIGNUP_GENDER_IDENTITY_TITLE"),
            dateOfBirthTitle: String(moduleLocalized: "UAP_SIGNUP_DATE_OF_BIRTH_TITLE"),
            signUpActionButtonTitle: String(moduleLocalized: "UAP_SIGNUP_ACTION_BUTTON_TITLE"),
            defaultSignUpFailedError: String(moduleLocalized: "UAP_SIGNUP_FAILED_DEFAULT_ERROR")
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
        public let passwordRepeat: FieldLocalization
        /// <#Description#>
        public let passwordNotEqualError: String
        /// <#Description#>
        public let givenName: FieldLocalization
        /// <#Description#>
        public let familyName: FieldLocalization
        /// <#Description#>
        public let genderIdentityTitle: String
        /// <#Description#>
        public let dateOfBirthTitle: String
        /// <#Description#>
        public let signUpActionButtonTitle: String
        /// <#Description#>
        public let defaultSignUpFailedError: String
        
        
        /// <#Description#>
        /// - Parameters:
        ///   - buttonTitle: <#buttonTitle description#>
        ///   - navigationTitle: <#navigationTitle description#>
        ///   - username: <#username description#>
        ///   - password: <#password description#>
        ///   - passwordRepeat: <#passwordRepeat description#>
        ///   - passwordNotEqualError: <#passwordNotEqualError description#>
        ///   - givenName: <#givenName description#>
        ///   - familyName: <#familyName description#>
        ///   - genderIdentityTitle: <#genderIdentityTitle description#>
        ///   - dateOfBirthTitle: <#dateOfBirthTitle description#>
        ///   - signUpActionButtonTitle: <#signUpActionButtonTitle description#>
        ///   - defaultSignUpFailedError: <#defaultSignUpFailedError description#>
        public init(
            buttonTitle: String = SignUp.default.buttonTitle,
            navigationTitle: String = SignUp.default.navigationTitle,
            username: FieldLocalization = SignUp.default.username,
            password: FieldLocalization = SignUp.default.password,
            passwordRepeat: FieldLocalization = SignUp.default.passwordRepeat,
            passwordNotEqualError: String = SignUp.default.passwordNotEqualError,
            givenName: FieldLocalization = SignUp.default.givenName,
            familyName: FieldLocalization = SignUp.default.familyName,
            genderIdentityTitle: String = SignUp.default.genderIdentityTitle,
            dateOfBirthTitle: String = SignUp.default.dateOfBirthTitle,
            signUpActionButtonTitle: String = SignUp.default.signUpActionButtonTitle,
            defaultSignUpFailedError: String = SignUp.default.defaultSignUpFailedError
        ) {
            self.buttonTitle = buttonTitle.localized
            self.navigationTitle = navigationTitle.localized
            self.username = username
            self.password = password
            self.passwordRepeat = passwordRepeat
            self.passwordNotEqualError = passwordNotEqualError.localized
            self.givenName = givenName
            self.familyName = familyName
            self.genderIdentityTitle = genderIdentityTitle.localized
            self.dateOfBirthTitle = dateOfBirthTitle.localized
            self.signUpActionButtonTitle = signUpActionButtonTitle.localized
            self.defaultSignUpFailedError = defaultSignUpFailedError.localized
        }
    }
}
