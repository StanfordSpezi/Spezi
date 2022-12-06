//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


struct SignUpOptions: OptionSet {
    static let usernameAndPassword = SignUpOptions(rawValue: 1 << 0)
    static let name = SignUpOptions(rawValue: 1 << 1)
    static let genderIdentity = SignUpOptions(rawValue: 1 << 2)
    static let dateOfBirth = SignUpOptions(rawValue: 1 << 3)
    
    static let `default`: SignUpOptions = [.usernameAndPassword, .name, .genderIdentity, .dateOfBirth]
    
    
    let rawValue: Int
}
