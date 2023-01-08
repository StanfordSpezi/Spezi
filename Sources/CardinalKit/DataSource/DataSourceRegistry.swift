//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``DataSourceRegistry`` can recieve data from data sources using the ``DataSourceRegistry/registerDataSource(_:)`` method.
/// Each ``DataSourceRegistry`` has a ``DataSourceRegistry/BaseType`` that all data sources should provide.
/// Use ``Adapter``s to transform data of different data sources.
public protocol DataSourceRegistry<BaseType, RemovalContext>: Actor {
    /// The ``DataSourceRegistry/BaseType`` that all data sources should provide.
    associatedtype BaseType: Identifiable, Sendable where BaseType.ID: Sendable & Identifiable, BaseType.ID == RemovalContext.ID
    /// <#Description#>
    associatedtype RemovalContext: Identifiable, Sendable
    
    
    /// Registers a new data source for the ``DataSourceRegistry``.
    /// - Parameter asyncSequence: The `TypedAsyncSequence<DataChange<BaseType>>` providing the data to the ``DataSourceRegistry``.
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>)
}

// protocol DataSourceRegistryRemovalContext<BaseType>: Identifiable where ID == BaseType.ID {
//    associatedtype BaseType: Identifiable where BaseType.ID: Sendable & Identifiable
//
//
//    var metaType: Any.Type { get }
// }
//
// class TestClass: Identifiable {
//    var id: String {
//        "..."
//    }
// }
// class TestSubClass {}
//
// struct Test: DataSourceRegistryRemovalContext {
//    typealias BaseType = TestClass
//
//
//    var id: String {
//        "..."
//    }
//
//    var metaType: Any.Type {
//        return TestSubClass.self
//    }
//
//    func test() {
//        let test = Test()
//        switch test.metaType {
//        case is TestClass.Type:
//            break
//        default:
//            break
//        }
//
//        let aType = type(of: test)
//    }
// }
// extension DataSourceRegistry {
//    func test(_ element: DataChange<BaseType, some DataSourceRegistryRemovalContext<BaseType>>) {
//
//    }
// }


extension DataSourceRegistry {
    /// Overload of the ``DataSourceRegistry/registerDataSource(_:)`` method to recieve `AsyncStream`s.
    /// - Parameter asyncStream: The `AsyncStream<DataChange<BaseType, RemovalContext>>` providing the data to the ``DataSourceRegistry``.
    public func registerDataSource(asyncStream: AsyncStream<DataChange<BaseType, RemovalContext>>) {
        registerDataSource(asyncStream)
    }
    
    /// Overload of the ``DataSourceRegistry/registerDataSource(_:)`` method to recieve `AsyncThrowingStream`s.
    /// - Parameter asyncThrowingStream: The `AsyncThrowingStream<DataChange<BaseType, RemovalContext>>` providing the data to the ``DataSourceRegistry``.
    public func registerDataSource(asyncThrowingStream: AsyncThrowingStream<DataChange<BaseType, RemovalContext>, Error>) {
        registerDataSource(asyncThrowingStream)
    }
}
