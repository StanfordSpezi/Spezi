//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``SingleValueAdapter`` is a ``Adapter`` that can be used to more simply transform data using the
/// ``SingleValueAdapter/transform(element:)`` and ``SingleValueAdapter/transform(removalContext:)`` functions.
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
/// The `IntToStringAdapter` can be transformed to a ``SingleValueAdapter`` by breaking up the
/// functionality in the ``SingleValueAdapter/transform(element:)`` and ``SingleValueAdapter/transform(removalContext:)`` methods:
/// ```swift
/// actor IntToStringSingleValueAdapter: SingleValueAdapter {
///     typealias InputElement = Int
///     typealias InputRemovalContext = InputElement.ID
///     typealias OutputElement = String
///     typealias OutputRemovalContext = OutputElement.ID
///
///
///     func transform(element: Int) throws -> String {
///         String(element)
///     }
///
///     func transform(removalContext: InputElement.ID) throws -> OutputElement.ID {
///         String(removalContext)
///     }
/// }
/// ```
///
/// See ``Adapter`` for more detail about data source registry adapters.
public protocol SingleValueAdapter<InputElement, InputRemovalContext, OutputElement, OutputRemovalContext>: Adapter {
    /// Map the element of the transformed async streams from additions.
    /// - Parameter element: The element that should be transformed.
    /// - Returns: Returns the transformed element.
    func transform(element: InputElement) async throws -> OutputElement
    
    /// Map the element's removal of the transformed async streams from removals.
    /// - Parameter removalContext: The element's removal context that should be transformed.
    /// - Returns: Returns the transformed removal context.
    func transform(removalContext: InputRemovalContext) async throws -> OutputRemovalContext
}


extension SingleValueAdapter {
    // A documentation for this methodd exists in the `Adapter` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func transform(
        _ asyncSequence: some TypedAsyncSequence<DataChange<InputElement, InputRemovalContext>>
    ) async -> any TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>> {
        asyncSequence.map { [self] element in
            switch element {
            case let .addition(element):
                return await .addition(try transform(element: element))
            case let .removal(removalContext):
                return await .removal(try transform(removalContext: removalContext))
            }
        }
    }
}
