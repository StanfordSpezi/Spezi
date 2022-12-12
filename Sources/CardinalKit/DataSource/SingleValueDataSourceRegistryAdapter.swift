//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``SingleValueDataSourceRegistryAdapter`` is a ``DataSourceRegistryAdapter`` that can be used to more simply transform data using the
/// ``SingleValueDataSourceRegistryAdapter/transform(element:)`` and ``SingleValueDataSourceRegistryAdapter/transform(id:)`` functions.
///
/// See ``DataSourceRegistryAdapter`` for more detail about data source registry adapters.
public protocol SingleValueDataSourceRegistryAdapter<InputType, OutputType>: DataSourceRegistryAdapter {
    /// Map the element of the transformed async streams from additions.
    /// - Parameter element: The element that should be transformed.
    /// - Returns: Returns the transformed element
    func transform(element: InputType) -> OutputType
    
    /// Map the element ids of the transformed async streams from removals.
    /// - Parameter id: The element's id that should be transformed.
    /// - Returns: Returns the transformed element id.
    func transform(id: InputType.ID) -> OutputType.ID
}


extension SingleValueDataSourceRegistryAdapter {
    // A documentation for this methodd exists in the `DataSourceRegistryAdapter` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func transform(
        _ asyncSequence: some TypedAsyncSequence<DataChange<InputType>>
    ) async -> any TypedAsyncSequence<DataChange<OutputType>> {
        asyncSequence.map { [self] element in
            switch element {
            case let .addition(element):
                return await .addition(transform(element: element))
            case let .removal(elementId):
                return await .removal(transform(id: elementId))
            }
        }
    }
}
