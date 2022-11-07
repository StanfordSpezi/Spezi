//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``Standard`` defines a common representation of resources using by different `CardinalKit` components.
public protocol Standard<BaseType>: Actor, Component where ComponentStandard == Self {
    associatedtype BaseType: Identifiable
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataSourceElement<BaseType>>)
}


extension Standard {
    public func registerDataSource(asyncStream: AsyncStream<DataSourceElement<BaseType>>) {
        registerDataSource(asyncStream)
    }
    
    public func registerDataSource(asyncThrowingStream: AsyncThrowingStream<DataSourceElement<BaseType>, Error>) {
        registerDataSource(asyncThrowingStream)
    }
}
