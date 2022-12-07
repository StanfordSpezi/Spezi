//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


/// The ``Account`` type is used to store and inject account-related information into the SwiftUI View hieray and enables interaction with the ``AccountService``s.
open class Account: ObservableObject {
    /// The ``User`` is intialized by AccountServices during the lifecycle of the application, allowing views to populate content with user information.
    open var user: User?
    
    ///  An account provides a collection of ``AccountService``s that are used to populate login, sign up, or reset password screens.
    open var accountServices: [any AccountService] {
        []
    }
}
