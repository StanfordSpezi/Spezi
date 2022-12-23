//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import Views


/// <#Description#>
public struct Localization: Codable {
    /// <#Description#>
    public static let `default` = Localization(
        login: Login.default,
        signUp: SignUp.default,
        resetPassword: ResetPassword.default
    )
    
    
    /// <#Description#>
    public let login: Login
    /// <#Description#>
    public let signUp: SignUp
    /// <#Description#>
    public let resetPassword: ResetPassword
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - login: <#login description#>
    ///   - signUp: <#signUp description#>
    ///   - resetPassword: <#resetPassword description#>
    public init(
        login: Login = Localization.default.login,
        signUp: SignUp = Localization.default.signUp,
        resetPassword: ResetPassword = Localization.default.resetPassword
    ) {
        self.login = login
        self.signUp = signUp
        self.resetPassword = resetPassword
    }
}
