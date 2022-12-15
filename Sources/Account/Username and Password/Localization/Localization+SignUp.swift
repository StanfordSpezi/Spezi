//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Views


extension Localization {
    public struct SignUp: Codable {
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
        
        
        public let buttonTitle: String
        public let navigationTitle: String
        public let username: FieldLocalization
        public let password: FieldLocalization
        public let passwordRepeat: FieldLocalization
        public let passwordNotEqualError: String
        public let givenName: FieldLocalization
        public let familyName: FieldLocalization
        public let genderIdentityTitle: String
        public let dateOfBirthTitle: String
        public let signUpActionButtonTitle: String
        public let defaultSignUpFailedError: String
        
        
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
            self.buttonTitle = buttonTitle
            self.navigationTitle = navigationTitle
            self.username = username
            self.password = password
            self.passwordRepeat = passwordRepeat
            self.passwordNotEqualError = passwordNotEqualError
            self.givenName = givenName
            self.familyName = familyName
            self.genderIdentityTitle = genderIdentityTitle
            self.dateOfBirthTitle = dateOfBirthTitle
            self.signUpActionButtonTitle = signUpActionButtonTitle
            self.defaultSignUpFailedError = defaultSignUpFailedError
        }
    }
}
