//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``DataSourceRegistryAdapter`` can be used to transfrom an ouput of a data source (`InputType`) to an `OutoutType`.
///
/// Use the ``DataSourceRegistryAdapterBuilder`` to offer developers to option to pass in a `DataSourceRegistryAdapter` instance to your components.
public protocol DataSourceRegistryAdapter<InputType, OutputType>: Actor {
    /// The input of the ``DataSourceRegistryAdapter``
    associatedtype InputType: Identifiable
    /// The output of the ``DataSourceRegistryAdapter``
    associatedtype OutputType: Identifiable
    
    
    /// Transforms any `TypedAsyncSequence<DataSourceElement<InputType>>` to an `TypedAsyncSequence` with
    /// the `TypedAsyncSequence<DataSourceElement<OutputType>>` generic constraint fulfilling the transformation,
    ///
    /// Implement this method in an instance of a `DataSourceRegistryAdapter`.
    /// - Parameter asyncSequence: The input `TypedAsyncSequence`.
    /// - Returns: The transformed `TypedAsyncSequence`.
    func transform(
        _ asyncSequence: some TypedAsyncSequence<DataSourceElement<InputType>>
    ) async -> any TypedAsyncSequence<DataSourceElement<OutputType>>
}
