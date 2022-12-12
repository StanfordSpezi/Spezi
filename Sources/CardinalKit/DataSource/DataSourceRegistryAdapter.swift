//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``DataSourceRegistryAdapter`` can be used to transfrom an ouput of a data source (`InputType`) to an `OutoutType`.
///
/// Use the ``DataSourceRegistryAdapterBuilder`` to offer developers to option to pass in a `DataSourceRegistryAdapter` instance to your components.
public protocol DataSourceRegistryAdapter<InputType, OutputType>: Actor {
    /// The input of the ``DataSourceRegistryAdapter``
    associatedtype InputType: Identifiable, Sendable where InputType.ID: Sendable
    /// The output of the ``DataSourceRegistryAdapter``
    associatedtype OutputType: Identifiable, Sendable where OutputType.ID: Sendable
    
    
    /// Transforms any `TypedAsyncSequence<DataChange<InputType>>` to an `TypedAsyncSequence` with
    /// the `TypedAsyncSequence<DataChange<OutputType>>` generic constraint fulfilling the transformation,
    ///
    /// Implement this method in an instance of a `DataSourceRegistryAdapter`.
    /// - Parameter asyncSequence: The input `TypedAsyncSequence`.
    /// - Returns: The transformed `TypedAsyncSequence`.
    func transform(
        _ asyncSequence: some TypedAsyncSequence<DataChange<InputType>>
    ) async -> any TypedAsyncSequence<DataChange<OutputType>>
}
