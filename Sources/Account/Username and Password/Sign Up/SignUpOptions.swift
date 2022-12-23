//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// <#Description#>
public struct SignUpOptions: OptionSet {
    /// <#Description#>
    public static let usernameAndPassword = SignUpOptions(rawValue: 1 << 0)
    /// <#Description#>
    public static let name = SignUpOptions(rawValue: 1 << 1)
    /// <#Description#>
    public static let genderIdentity = SignUpOptions(rawValue: 1 << 2)
    /// <#Description#>
    public static let dateOfBirth = SignUpOptions(rawValue: 1 << 3)
    
    /// <#Description#>
    public static let `default`: SignUpOptions = [.usernameAndPassword, .name, .genderIdentity, .dateOfBirth]
    
    
    public let rawValue: Int
    
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
