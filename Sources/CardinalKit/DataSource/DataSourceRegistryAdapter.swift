//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


public protocol DataSourceRegistryAdapter<InputType, OutputType>: Actor {
    associatedtype InputType: Identifiable
    associatedtype OutputType: Identifiable
    
    
    func transform(
        _ asyncSequence: some TypedAsyncSequence<DataSourceElement<InputType>>
    ) async -> any TypedAsyncSequence<DataSourceElement<OutputType>>
}
