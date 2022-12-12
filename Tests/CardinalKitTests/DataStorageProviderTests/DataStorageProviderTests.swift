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
    private actor DataStorageExample<ComponentStandard: Standard>: DataStorageProvider {
        typealias Adapter = any EncodableAdapter<ComponentStandard.BaseType, String>
        
        
        let adapter: Adapter
        
        
        init(adapter: Adapter) {
            self.adapter = adapter
        }
        
        init() where ComponentStandard.BaseType: Encodable & Sendable, ComponentStandard.BaseType.ID: LosslessStringConvertible {
            self.adapter = IdentityEncodableAdapter()
        }
        
        
        func process(_ element: DataSourceElement<ComponentStandard.BaseType>) async throws {
            switch element {
            case let .addition(element):
                async let transformedElement = adapter.transform(element: element)
                let data = try await JSONEncoder().encode(transformedElement)
                print("Upload \(data) ...")
                try await _Concurrency.Task.sleep(for: .seconds(2))
                print("Upload successsful.")
            case let .removal(id):
                print("Remove \(id)")
            }
        }
    }
    
    
    func testDataStorageProviderTests() {
        print("...")
    }
}
