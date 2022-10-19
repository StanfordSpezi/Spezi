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
    static func buildPartialBlock<C: StandardBasedConfiguration>(first configuration: C) -> TupleConfiguration<S> where C.ResourceRepresentation == S {
        TupleConfiguration(configuration)
    }

    static func buildPartialBlock<C: StandardBasedConfiguration>(accumulated: TupleConfiguration<S>, next: C) -> TupleConfiguration<S> where C.ResourceRepresentation == S {
        return TupleConfiguration(accumulated, next)
    }


    /// A method that enables the use of if-else statements for `Configuration`s
    /// - Parameter first: The `Configuration` within the if statement
    /// - Returns: The `Configuration` within the if statement
    static func buildEither<C: StandardBasedConfiguration>(first: C) -> TupleConfiguration<S> where C.ResourceRepresentation == S {
        TupleConfiguration(first)
    }


    /// A method that enables the use of if-else statements for `Configuration`s
    /// - Parameter second: The `Configuration` within the if statement
    /// - Returns: The `Configuration` within the if statement
    static func buildEither<C: StandardBasedConfiguration>(second: C) -> TupleConfiguration<S> where C.ResourceRepresentation == S {
        TupleConfiguration(second)
    }
}
