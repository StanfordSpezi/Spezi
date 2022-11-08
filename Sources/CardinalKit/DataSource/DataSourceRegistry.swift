//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


public protocol DataSourceRegistry<BaseType>: Actor {
    associatedtype BaseType: Identifiable
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataSourceElement<BaseType>>)
}


extension DataSourceRegistry {
    public func registerDataSource(asyncStream: AsyncStream<DataSourceElement<BaseType>>) {
        registerDataSource(asyncStream)
    }
    
    public func registerDataSource(asyncThrowingStream: AsyncThrowingStream<DataSourceElement<BaseType>, Error>) {
        registerDataSource(asyncThrowingStream)
    }
}
