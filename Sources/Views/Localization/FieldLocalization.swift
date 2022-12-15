//
//  File.swift
//  
//
//  Created by Paul Shmiedmayer on 12/14/22.
//

import Foundation


public struct FieldLocalization: Codable {
    public let title: String
    public let placeholder: String
    
    
    public init<Title: StringProtocol, Placeholder: StringProtocol>(title: Title, placeholder: Placeholder) {
        self.title = title.localized
        self.placeholder = placeholder.localized
    }
}
