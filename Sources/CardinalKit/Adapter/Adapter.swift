//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``Adapter`` can be used to transfrom an input `DataChange` (`InputElement` and `InputRemovalContext`)
/// to an output `DataChange` (`OutputElement` and `OutputRemovalContext`).
///
///
/// The following example demonstrates a simple ``Adapter`` that transforms an `Int` to a `String` (both have been extended to conform to `Identifiable`).
/// The mapping function uses the ``DataChange/map(element:removalContext:)`` function.
/// ```swift
/// actor IntToStringAdapter: Adapter {
///     typealias InputElement = Int
///     typealias InputRemovalContext = InputElement.ID
///     typealias OutputElement = String
///     typealias OutputRemovalContext = OutputElement.ID
///
///
///     func transform(
///         _ asyncSequence: some TypedAsyncSequence<DataChange<InputElement, InputRemovalContext>>
///     ) async -> any TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>> {
///         asyncSequence.map { element in
///             element.map(
///                 element: {
///                     String($0.id)
///                 },
///                 removalContext: {
///                     String($0.id)
///                 }
///             )
///         }
///     }
/// }
/// ```
///
/// The ``SingleValueAdapter`` provides a even more convenient way to implement adapters if the transformation can be done on a item-by-item basis.
///
/// Use the ``AdapterBuilder`` to offer developers to option to pass in a `Adapter` instance to your components:
/// ```swift
/// final class DataSourceExample<T: Identifiable>: Component {
///     typealias ComponentStandard = ExampleStandard
///     typealias DataSourceExampleAdapter = Adapter<T, T.ID, ExampleStandard.BaseType, ExampleStandard.RemovalContext>
///
///
///     @StandardActor var standard: ExampleStandard
///     let adapter: any DataSourceExampleAdapter
///
///
///     init(@AdapterBuilder<ExampleStandard.BaseType, ExampleStandard.RemovalContext> adapter: () -> (any DataSourceExampleAdapter)) {
///         self.adapter = adapter()
///     }
///
///
///     // ...
/// }
/// ```
public protocol Adapter<InputElement, InputRemovalContext, OutputElement, OutputRemovalContext>: Actor {
    /// The input element of the ``Adapter``
    associatedtype InputElement: Identifiable, Sendable where InputElement.ID: Sendable
    /// The input removal context of the ``Adapter``
    associatedtype InputRemovalContext: Identifiable, Sendable where InputElement.ID == InputRemovalContext.ID
    /// The output element of the ``Adapter``
    associatedtype OutputElement: Identifiable, Sendable where OutputElement.ID: Sendable
    /// The output removal context of the ``Adapter``
    associatedtype OutputRemovalContext: Identifiable, Sendable where OutputElement.ID == OutputRemovalContext.ID
    
    
    /// Transforms any `TypedAsyncSequence<DataChange<InputElement, InputRemovalContext>>` to an `TypedAsyncSequence` with
    /// the `TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>>` generic constraint fulfilling the transformation,
    ///
    /// Implement this method in an instance of a `Adapter`.
    /// - Parameter asyncSequence: The input `TypedAsyncSequence`.
    /// - Returns: The transformed `TypedAsyncSequence`.
    func transform(
        _ asyncSequence: some TypedAsyncSequence<DataChange<InputElement, InputRemovalContext>>
    ) async -> any TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>>
}


extension Adapter {
    /// Map a collection of `DataChange` elements using the adapter to an ``TypedAsyncSequence``.
    /// - Parameter dataChanges: The data changes that should be transformed.
    /// - Returns: Returns the mapped elements using the ``Adapter``'s ``transform(_:)`` function.
    public func transformDataChanges(
        _ dataChanges: [DataChange<InputElement, InputRemovalContext>]
    ) async -> any TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>> {
        await transform(
            AsyncStream { continuation in
                for dataChange in dataChanges {
                    continuation.yield(dataChange)
                }
                continuation.finish()
            }
        )
    }
}
