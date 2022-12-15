//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
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
