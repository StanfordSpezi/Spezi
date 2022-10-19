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
public enum ConfigurationBuilder<S: Standard> {
    public static func buildFinalResult(_ component: [AnyConfiguration]) -> AnyConfiguration {
        component
    }
    
    public static func buildExpression<C: Configuration>(_ expression: C) -> [AnyConfiguration] where C.ResourceRepresentation == S {
        [expression]
    }
    
    public static func buildBlock(_ components: AnyConfiguration...) -> [AnyConfiguration] {
        components
    }
    
    static func buildOptional(_ component: [AnyConfiguration]?) -> [AnyConfiguration] {
        component ?? []
    }

    static func buildEither(first: [AnyConfiguration]) -> [AnyConfiguration] {
        first
    }
    
    static func buildEither(second: [AnyConfiguration]) -> [AnyConfiguration] {
        second
    }
    
    public static func buildArray(_ components: [[AnyConfiguration]]) -> [AnyConfiguration] {
        components.flatMap { $0 }
    }
}
