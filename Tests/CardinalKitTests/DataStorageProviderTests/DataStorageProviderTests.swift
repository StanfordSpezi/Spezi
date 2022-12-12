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
    enum MockUpload {
        case post(String)
        case delete(String)
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
        
        
        func process(_ element: DataSourceElement<ComponentStandard.BaseType>) async throws {
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
    
    
    func testDataStorageProviderTests() {
        #warning("Add test cases")
    }
}
