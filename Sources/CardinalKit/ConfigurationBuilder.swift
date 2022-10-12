//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//
//
// This code is based on the Apodini (https://github.com/Apodini/Apodini) project.
//
// SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the Apodini project authors
//
// SPDX-License-Identifier: MIT
//


/// A function builder used to aggregate multiple `Configuration`s
@resultBuilder
enum ConfigurationBuilder {
    /// Builder function for multiple`Configuration`s
    /// - Parameter configurations: A variadic number of `Configuration`s.
    /// - Returns: A collection of `Configuration`s.
    static func buildBlock(_ configurations: Configuration...) -> [Configuration] {
        configurations
    }
    
    
    /// Builder function for conditional`Configuration`s
    /// - Parameter configurations: A conditional `Configuration`.
    /// - Returns: Either the `Configuration` within the branch if the condition evaluates to `true` or an `EmptyConfiguration`.
    static func buildIf(_ configuration: Configuration?) -> Configuration {
        configuration ?? EmptyConfiguration()
    }
    
    
    /// A method that enables the use of if-else statements for `Configuration`s
    /// - Parameter first: The `Configuration` within the if statement
    /// - Returns: The `Configuration` within the if statement
    static func buildEither<C: Configuration>(first: C) -> C {
        first
    }
    
    
    /// A method that enables the use of if-else statements for `Configuration`s
    /// - Parameter second: The `Configuration` within the if statement
    /// - Returns: The `Configuration` within the if statement
    static func buildEither<C: Configuration>(second: C) -> C {
        second
    }
}
