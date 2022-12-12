//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import SwiftUI
import XCTest
import XCTRuntimeAssertions


final class DataStorageProviderTests: XCTestCase {
    private enum MockUpload {
        case post(String)
        case delete(String)
        
        
        func assertPost(is value: String) {
            guard case let .post(test) = self else {
                XCTFail("Expected a .post and got: \(self)")
                return
            }
            XCTAssertEqual(test, value)
        }
        
        func assertDelete(is value: String) {
            guard case let .delete(test) = self else {
                XCTFail("Expected a .delete and got: \(self)")
                return
            }
            XCTAssertEqual(test, value)
        }
    }
    
    
    private actor DataStorageExample<ComponentStandard: Standard>: DataStorageProvider {
        typealias Adapter = any EncodableAdapter<ComponentStandard.BaseType, String>
        
        
        let adapter: Adapter
        let mockUpload: (MockUpload) -> Void
        
        
        init(adapter: Adapter, mockUpload: @escaping (MockUpload) -> Void) {
            self.adapter = adapter
            self.mockUpload = mockUpload
        }
        
        init(
            mockUpload: @escaping (MockUpload) -> Void
        ) where ComponentStandard.BaseType: Encodable & Sendable, ComponentStandard.BaseType.ID: LosslessStringConvertible {
            self.adapter = IdentityEncodableAdapter()
            self.mockUpload = mockUpload
        }
        
        
        func process(_ element: DataChange<ComponentStandard.BaseType>) async throws {
            switch element {
            case let .addition(element):
                async let transformedElement = adapter.transform(element: element)
                let data = try await JSONEncoder().encode(transformedElement)
                let string = String(decoding: data, as: UTF8.self)
                mockUpload(.post(string))
            case let .removal(id):
                async let stringId = transform(id, using: adapter)
                await mockUpload(.delete(stringId))
            }
        }
        
        
        private func transform(
            _ id: ComponentStandard.BaseType.ID,
            using adapter: some EncodableAdapter<ComponentStandard.BaseType, String>
        ) async -> String {
            await adapter.transform(id: id)
        }
    }
    
    
    private actor DataStorageProviderStandard: Standard {
        typealias BaseType = CustomDataSourceType<String>
        
        
        struct CustomDataSourceType<T: Encodable & Hashable>: Encodable, Equatable, Identifiable {
            let id: T
        }
        
        
        @DataStorageProviders
        var dataSources: [any DataStorageProvider<DataStorageProviderStandard>]
        
        
        func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType>>) {
            Task {
                do {
                    for try await element in asyncSequence {
                        switch element {
                        case let .addition(element):
                            for dataSource in dataSources {
                                try await dataSource.process(.addition(element))
                            }
                        case let .removal(id):
                            for dataSource in dataSources {
                                try await dataSource.process(.removal(id))
                            }
                        }
                    }
                } catch {
                    XCTFail("Failed data source of type \(String(describing: type(of: asyncSequence))) with \(error).")
                }
            }
        }
    }
    
    private class DataStorageProviderApplicationDelegate: CardinalKitAppDelegate {
        let mockUpload: (MockUpload) -> Void
        
        
        override var configuration: Configuration {
            Configuration(standard: DataStorageProviderStandard()) {
                DataStorageExample(mockUpload: mockUpload)
            }
        }
        
        
        init(mockUpload: @escaping (MockUpload) -> Void) {
            self.mockUpload = mockUpload
        }
    }
    
    
    @MainActor
    func testDataStorageProviderTests() async throws {
        let expectation = expectation(description: "Timeout Expection")
        expectation.isInverted = true
        
        var count = 0
        let delegate = DataStorageProviderApplicationDelegate { mockUpload in
            switch count {
            case 0:
                mockUpload.assertPost(is: #"{"id":"42"}"#)
            case 1:
                mockUpload.assertPost(is: #"{"id":"43"}"#)
            case 2:
                mockUpload.assertPost(is: #"{"id":"44"}"#)
            case 3:
                mockUpload.assertDelete(is: "44")
            default:
                XCTFail("Too many calls to the mock upload function.")
            }
            count += 1
        }
        
        let cardinalKit = try XCTUnwrap(delegate.cardinalKit as? CardinalKit<DataStorageProviderStandard>)
        await cardinalKit.standard.registerDataSource(
            asyncStream: AsyncStream { continuation in
                continuation.yield(DataChange.addition(DataStorageProviderStandard.CustomDataSourceType(id: "42")))
                continuation.yield(DataChange.addition(DataStorageProviderStandard.CustomDataSourceType(id: "43")))
                continuation.yield(DataChange.addition(DataStorageProviderStandard.CustomDataSourceType(id: "44")))
                continuation.yield(DataChange.removal("44"))
            }
        )
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(count, 4)
    }
    
    
    func testInjectionPreconditionDependencyPropertyWrapper() throws {
        try XCTRuntimePrecondition {
            _ = _DataStorageProvidersPropertyWrapper<MockStandard>().wrappedValue
        }
    }
}
