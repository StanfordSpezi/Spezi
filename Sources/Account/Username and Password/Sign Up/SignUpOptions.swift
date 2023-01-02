//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// Represents a set of options for fields to display on a signup view
public struct SignUpOptions: OptionSet {
    /// Option to display username and password fields
    public static let usernameAndPassword = SignUpOptions(rawValue: 1 << 0)
    /// Option to display name entry fields
    public static let name = SignUpOptions(rawValue: 1 << 1)
    /// Option to display a gender identity entry field
    public static let genderIdentity = SignUpOptions(rawValue: 1 << 2)
    /// Option to display a date of birth entry field
    public static let dateOfBirth = SignUpOptions(rawValue: 1 << 3)
    
    /// A default set of signup options, including username and password, name, gender identity, and date of birth
    public static let `default`: SignUpOptions = [.usernameAndPassword, .name, .genderIdentity, .dateOfBirth]
    
    
    public let rawValue: Int
    
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
