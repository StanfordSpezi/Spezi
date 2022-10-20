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


/// A function builder used to aggregate multiple `Component`s
@resultBuilder
public enum ComponentBuilder<S: Standard> {
    /// If declared, provides contextual type information for statement expressions to translate them into partial results.
    static func buildExpression<C: Component>(_ expression: C) -> [_AnyComponent] where C.ResourceRepresentation == S {
        [expression]
    }
    
    /// Required by every result builder to build combined results from statement blocks.
    static func buildBlock(_ components: _AnyComponent...) -> [_AnyComponent] {
        components
    }
    
    /// Enables support for `if` statements that do not have an `else`.
    static func buildOptional(_ component: [_AnyComponent]?) -> [_AnyComponent] { // swiftlint:disable:this discouraged_optional_collection
        component ?? []
    }

    /// With buildEither(second:), enables support for 'if-else' and 'switch' statements by folding conditional results into a single result.
    static func buildEither(first: [_AnyComponent]) -> [_AnyComponent] {
        first
    }
    
    /// With buildEither(first:), enables support for 'if-else' and 'switch' statements by folding conditional results into a single result.
    static func buildEither(second: [_AnyComponent]) -> [_AnyComponent] {
        second
    }
    
    /// Enables support for 'for..in' loops by combining the results of all iterations into a single result.
    static func buildArray(_ components: [[_AnyComponent]]) -> [_AnyComponent] {
        components.flatMap { $0 }
    }
    
    /// If declared, this will be called on the partial result of an 'if #available' block to allow the result builder to erase type information.
    static func buildLimitedAvailability(_ component: [_AnyComponent]) -> [_AnyComponent] {
        component
    }
    
    /// If declared, this will be called on the partial result from the outermost block statement to produce the final returned result.
    public static func buildFinalResult(_ component: [_AnyComponent]) -> _AnyComponent {
        component
    }
}
