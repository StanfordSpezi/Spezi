//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// An ``AccountService`` describes the mechanism for account management components to display login UI elements
public protocol AccountService: Sendable, AnyObject, Identifiable {
    /// A `View` erased as an `AnyView` that will be displayd in login-related user interfaces
    var loginButton: AnyView { get }
    
    
    /// Injects an ``Account`` instance in a ``AccountService`` instance.
    /// - Parameter account: The ``Account`` instance used to store information retrieved in the `AccountService`.
    func inject(account: Account)
}


extension AccountService {
    // A documentation for this methodd exists in the `Identifiable` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public var id: String {
        String(describing: type(of: self))
    }
}
