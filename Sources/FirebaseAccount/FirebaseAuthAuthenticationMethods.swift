//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Definition of the authentication methods supported by the FirebaseAccount module.
public struct FirebaseAuthAuthenticationMethods: OptionSet {
    /// E-Mail and password-based authentication.
    public static let emailAndPassword = FirebaseAuthAuthenticationMethods(rawValue: 1 << 0)
    
    /// All authentication methods.
    public static let all: FirebaseAuthAuthenticationMethods = [.emailAndPassword]
    
    
    public let rawValue: Int
    
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
