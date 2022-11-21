//
//  File.swift
//  
//
//  Created by Paul Shmiedmayer on 11/21/22.
//

import Foundation


struct SignUpOptions: OptionSet {
    let rawValue: Int
    
    
    static let usernameAndPassword = SignUpOptions(rawValue: 1 << 0)
    static let name = SignUpOptions(rawValue: 1 << 1)
    static let genderIdentity = SignUpOptions(rawValue: 1 << 2)
    static let dateOfBirth = SignUpOptions(rawValue: 1 << 3)
    static let phoneNumber = SignUpOptions(rawValue: 1 << 4)
    
    static let `default`: SignUpOptions = [.usernameAndPassword, .name]
}
