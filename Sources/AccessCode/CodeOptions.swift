//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public struct CodeOptions: OptionSet {
    /// <#Description#>
    public static let fourDigitNumeric = CodeOptions(rawValue: 1 << 0)
    /// <#Description#>
    public static let sixDigitNumeric = CodeOptions(rawValue: 1 << 1)
    /// <#Description#>
    public static let customNumeric = CodeOptions(rawValue: 1 << 2)
    /// <#Description#>
    public static let customAlphanumeric = CodeOptions(rawValue: 1 << 3)
    
    /// <#Description#>
    public static let finiteNumeric: CodeOptions = [.fourDigitNumeric, .sixDigitNumeric]
    /// <#Description#>
    public static let numeric: CodeOptions = [.fourDigitNumeric, .sixDigitNumeric, .customNumeric]
    /// <#Description#>
    public static let all: CodeOptions = [.fourDigitNumeric, .sixDigitNumeric, .customNumeric, .customAlphanumeric]
    
    
    public let rawValue: Int
    
    
    /// <#Description#>
    /// - Parameter rawValue: <#rawValue description#>
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
