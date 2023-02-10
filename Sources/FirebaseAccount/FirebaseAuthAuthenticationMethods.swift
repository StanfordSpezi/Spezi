//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public struct FirebaseAuthAuthenticationMethods: OptionSet {
    /// <#Description#>
    public static let emailAndPassword = FirebaseAuthAuthenticationMethods(rawValue: 1 << 0)
    
    /// <#Description#>
    public static let all: FirebaseAuthAuthenticationMethods = [.emailAndPassword]
    
    
    public let rawValue: Int
    
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
