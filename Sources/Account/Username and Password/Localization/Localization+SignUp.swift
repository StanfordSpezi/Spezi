//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Localization {
    public struct SignUp: Codable {
        public static let `default` = SignUp(
            buttonTitle: String(moduleLocalized: "UAP_SIGNUP_BUTTION_TITLE"),
            navigationTitle: String(moduleLocalized: "UAP_SIGNUP_NAVIGATION_TITLE"),
            username: Localization.Field(
                title: String(moduleLocalized: "UAP_SIGNUP_USERNAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_USERNAME_PLACEHOLDER")
            ),
            password: Localization.Field(
                title: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_PLACEHOLDER")
            ),
            passwordRepeat: Localization.Field(
                title: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_REPEAT_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_REPEAT_PLACEHOLDER")
            ),
            passwordNotEqualError: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_NOT_EQUAL_ERROR"),
            givenName: Localization.Field(
                title: String(moduleLocalized: "UAP_SIGNUP_GIVEN_NAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_GIVEN_NAME_PLACEHOLDER")
            ),
            familyName: Localization.Field(
                title: String(moduleLocalized: "UAP_SIGNUP_FAMILY_NAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_FAMILY_NAME_PLACEHOLDER")
            ),
            genderIdentityTitle: String(moduleLocalized: "UAP_SIGNUP_GENDER_IDENTITY_TITLE"),
            dateOfBirthTitle: String(moduleLocalized: "UAP_SIGNUP_DATE_OF_BIRTH_TITLE"),
            signUpActionButtonTitle: String(moduleLocalized: "UAP_SIGNUP_ACTION_BUTTON_TITLE")
        )
        
        
        public let buttonTitle: String
        public let navigationTitle: String
        public let username: Field
        public let password: Field
        public let passwordRepeat: Field
        public let passwordNotEqualError: String
        public let givenName: Field
        public let familyName: Field
        public let genderIdentityTitle: String
        public let dateOfBirthTitle: String
        public let signUpActionButtonTitle: String
        
        
        public init(
            buttonTitle: String = SignUp.default.buttonTitle,
            navigationTitle: String = SignUp.default.navigationTitle,
            username: Field = SignUp.default.username,
            password: Field = SignUp.default.password,
            passwordRepeat: Field = SignUp.default.passwordRepeat,
            passwordNotEqualError: String = SignUp.default.passwordNotEqualError,
            givenName: Field = SignUp.default.givenName,
            familyName: Field = SignUp.default.familyName,
            genderIdentityTitle: String = SignUp.default.genderIdentityTitle,
            dateOfBirthTitle: String = SignUp.default.dateOfBirthTitle,
            signUpActionButtonTitle: String = SignUp.default.signUpActionButtonTitle
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
        }
    }
}
