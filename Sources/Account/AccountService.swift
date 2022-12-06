//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// An ``AccountService`` describes the mechanism for account management components to display login, signUp, and account-related UI elements
public protocol AccountService: Identifiable {
    /// A `View` erased as an `AnyView` that will be displayd in login-related user interfaces
    var loginButton: AnyView { get }
    /// A `View` erased as an `AnyView` that will be displayd in sign up-related user interfaces
    var signUpButton: AnyView { get }
    
    
    /// Creates a new ``AccountService`` using an ``Account`` instance.
    /// - Parameter account: The ``Account`` instance used to store information retrieved in the `AccountService`.
    init(account: Account)
}


extension AccountService {
    public var signUpButton: AnyView {
        loginButton
    }
    
    public var id: String {
        String(describing: type(of: self))
    }
}
