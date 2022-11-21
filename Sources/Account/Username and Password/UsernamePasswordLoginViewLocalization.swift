//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public struct UsernamePasswordLoginViewLocalization {
    public let navigationTitle: String
    public let usernameTitle: String
    public let passwordTitle: String
    public let usernamePlaceholder: String
    public let passwordPlaceholder: String
    public let loginButtonTitle: String
    
    
    public static let `default` = UsernamePasswordLoginViewLocalization(
        navigationTitle: String(localized: "LOGIN_UAP_NAVIGATION_TITLE", bundle: .module),
        usernameTitle: String(localized: "LOGIN_UAP_USERNAME_TITLE", bundle: .module),
        passwordTitle: String(localized: "LOGIN_UAP_PASSWORD_TITLE", bundle: .module),
        usernamePlaceholder: String(localized: "LOGIN_UAP_USERNAME_PLACEHOLDER", bundle: .module),
        passwordPlaceholder: String(localized: "LOGIN_UAP_PASSWORD_PLACEHOLDER", bundle: .module),
        loginButtonTitle: String(localized: "LOGIN_UAP_LOGIN_BUTTON_TITLE", bundle: .module)
    )
    
    
    public init(
        navigationTitle: String = `default`.navigationTitle,
        usernameTitle: String = `default`.usernameTitle,
        passwordTitle: String = `default`.passwordTitle,
        usernamePlaceholder: String = `default`.usernamePlaceholder,
        passwordPlaceholder: String = `default`.passwordPlaceholder,
        loginButtonTitle: String = `default`.loginButtonTitle
    ) {
        self.navigationTitle = navigationTitle
        self.usernameTitle = usernameTitle
        self.passwordTitle = passwordTitle
        self.usernamePlaceholder = usernamePlaceholder
        self.passwordPlaceholder = passwordPlaceholder
        self.loginButtonTitle = loginButtonTitle
    }
}
