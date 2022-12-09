//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


/// The ``UsernamePasswordAccountService`` enables a username and password based login.
///
/// Other ``AccountService``s can be created by subclassing the ``UsernamePasswordAccountService`` and overriding the ``UsernamePasswordAccountService/localization``,
/// buttons like the ``UsernamePasswordAccountService/loginButton``, or overriding the ``UsernamePasswordAccountService/login(username:password:)`` and ``UsernamePasswordAccountService/button(_:destination:)`` functions.
open class UsernamePasswordAccountService: @unchecked Sendable, AccountService, ObservableObject {
    /// The ``Account/Account`` instance that can be used to interact with the ``Account/Account/user``.
    public weak var account: Account?
    
    
    /// The ``Localization`` used by the views presented in the ``UsernamePasswordAccountService`` or its subclasses.
    open var localization: Localization {
        Localization.default
    }
    
    /// The button that should be displayed in login-related views to represent the ``UsernamePasswordAccountService`` or its subclasses.
    open var loginButton: AnyView {
        button(localization.login.buttonTitle, destination: UsernamePasswordLoginView())
    }

    
    /// Creates a new instance of a ``UsernamePasswordAccountService``
    public init() { }
    
    
    public func inject(account: Account) {
        self.account = account
    }
    
    /// The function is called when a user is logged in.
    ///
    /// You can use views like the ``UsernamePasswordLoginView`` to display user interfaces for logging in users or create your own views and call ``UsernamePasswordAccountService/login(username:password:)``
    /// - Parameters:
    ///   - username: The username that should be used in the login process
    ///   - password: The password that should be used in the login process
    open func login(username: String, password: String) async throws { }
    
    
    /// Creates a resuable button styled in accordance to the ``UsernamePasswordAccountService`` or its subclasses.
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - destination: The destination of the button.
    /// - Returns: Returns the styled button in accordance to the ``UsernamePasswordAccountService`` or its subclasses.
    open func button<V: View>(_ title: String, destination: V) -> AnyView {
        AnyView(
            NavigationLink {
                destination
                    .environmentObject(self as UsernamePasswordAccountService)
            } label: {
                AccountServiceButton {
                    Image(systemName: "ellipsis.rectangle")
                        .font(.title2)
                    Text(title)
                }
            }
        )
    }
}
