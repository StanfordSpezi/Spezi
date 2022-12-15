//
//  File.swift
//  
//
//  Created by Paul Shmiedmayer on 12/14/22.
//

import Foundation


/// <#Description#>
public struct FieldLocalization: Codable {
    /// <#Description#>
    public let title: String
    /// <#Description#>
    public let placeholder: String
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - placeholder: <#placeholder description#>
    public init<Title: StringProtocol, Placeholder: StringProtocol>(title: Title, placeholder: Placeholder) {
        self.title = title.localized
        self.placeholder = placeholder.localized
    }
}
