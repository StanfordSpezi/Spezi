//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A function builder used to aggregate multiple ``Module``s
@resultBuilder
public enum ModuleBuilder {
    /// If declared, provides contextual type information for statement expressions to translate them into partial results.
    public static func buildExpression<M: Module>(_ expression: M) -> [any Module] {
        [expression]
    }
    
    /// Required by every result builder to build combined results from statement blocks.
    public static func buildBlock(_ modules: [any Module]...) -> [any Module] {
        modules.flatMap { $0 }
    }
    
    /// Enables support for `if` statements that do not have an `else`.
    public static func buildOptional(_ module: [any Module]?) -> [any Module] {
        // swiftlint:disable:previous discouraged_optional_collection
        // The optional collection is a requirement defined by @resultBuilder, we can not use a non-optional collection here.
        module ?? []
    }

    /// With buildEither(second:), enables support for 'if-else' and 'switch' statements by folding conditional results into a single result.
    public static func buildEither(first: [any Module]) -> [any Module] {
        first
    }
    
    /// With buildEither(first:), enables support for 'if-else' and 'switch' statements by folding conditional results into a single result.
    public static func buildEither(second: [any Module]) -> [any Module] {
        second
    }
    
    /// Enables support for 'for..in' loops by combining the results of all iterations into a single result.
    public static func buildArray(_ modules: [[any Module]]) -> [any Module] {
        modules.flatMap { $0 }
    }
    
    /// If declared, this will be called on the partial result of an 'if #available' block to allow the result builder to erase type information.
    public static func buildLimitedAvailability(_ module: [any Module]) -> [any Module] {
        module
    }
    
    /// If declared, this will be called on the partial result from the outermost block statement to produce the final returned result.
    public static func buildFinalResult(_ module: [any Module]) -> ModuleCollection {
        ModuleCollection(elements: module)
    }
}
