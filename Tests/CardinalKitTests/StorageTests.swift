//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import os
import XCTest


protocol TestStorageTypes: Equatable {
    var value: Int { get }
}


final class StorageTests: XCTestCase {
    struct TestStorageStruct: StorageKey, TestStorageTypes {
        typealias Value = Self
        
        var value: Int
    }
    
    class TestStorageClass: StorageKey, TestStorageTypes {
        var value: Int
        
        
        init(value: Int) {
            self.value = value
        }
        
        
        static func == (lhs: StorageTests.TestStorageClass, rhs: StorageTests.TestStorageClass) -> Bool {
            lhs.value == rhs.value
        }
    }
    
    enum TestStorageKey: StorageKey {
        typealias Value = TestStorageClass
    }
    

    func testSetAndGet() async throws {
        let storage = Storage()
        
        let testStorageStruct = TestStorageStruct(value: 42)
        await storage.set(TestStorageStruct.self, to: testStorageStruct)
        
        let contentOfStorageTestStorageStruct = await storage.get(TestStorageStruct.self)
        XCTAssertEqual(contentOfStorageTestStorageStruct, testStorageStruct)
        
        let newTestStorageStruct = TestStorageStruct(value: 24)
        await storage.set(TestStorageStruct.self, to: newTestStorageStruct)
        let newContentOfStorageTestStorageStruct = await storage.get(TestStorageStruct.self)
        XCTAssertEqual(newContentOfStorageTestStorageStruct, newTestStorageStruct)
        
        await storage.set(TestStorageStruct.self, to: nil)
        let newerContentOfStorageTestStorageStruct = await storage.get(TestStorageStruct.self)
        XCTAssertNil(newerContentOfStorageTestStorageStruct)
    }
    
    func testGetWithDefault() async throws {
        let storage = Storage()
        
        let testStorageStruct = TestStorageStruct(value: 42)
        
        let contentOfStorageTestStorageStruct = await storage.get(TestStorageStruct.self, default: testStorageStruct)
        XCTAssertEqual(contentOfStorageTestStorageStruct, testStorageStruct)
    }
    
    func testContains() async throws {
        let storage = Storage()
        
        let testStorageStruct = TestStorageStruct(value: 42)
        let shouldNotContainTestStorageStruct = await storage.contains(TestStorageStruct.self)
        XCTAssertFalse(shouldNotContainTestStorageStruct)
        
        await storage.set(TestStorageStruct.self, to: testStorageStruct)
        let shouldContainTestStorageStruct = await storage.contains(TestStorageStruct.self)
        XCTAssertTrue(shouldContainTestStorageStruct)
        
        await storage.set(TestStorageStruct.self, to: nil)
        let shouldNotContainTestStorageStructAgain = await storage.contains(TestStorageStruct.self)
        XCTAssertFalse(shouldNotContainTestStorageStructAgain)
    }
    
    func testGetAllThatConformTo() async throws {
        let storage = Storage()
        
        let testStorageStruct = TestStorageStruct(value: 42)
        await storage.set(TestStorageStruct.self, to: testStorageStruct)
        let testStorageClass = TestStorageClass(value: 42)
        await storage.set(TestStorageClass.self, to: testStorageClass)
        
        let testStorageTypes = await storage.get(allThatConformTo: (any TestStorageTypes).self)
        XCTAssertEqual(testStorageTypes.count, 2)
        for testStorageType in testStorageTypes {
            XCTAssertEqual(testStorageType.value, 42)
        }
    }
    
    func testClear() async throws {
        let storage = Storage()
        
        let testStorageStruct = TestStorageStruct(value: 42)
        await storage.set(TestStorageStruct.self, to: testStorageStruct)
        
        await storage.clear()
        
        let newerContentOfStorageTestStorageStruct = await storage.get(TestStorageStruct.self)
        XCTAssertNil(newerContentOfStorageTestStorageStruct)
    }
    
    func testMutationClass() async throws {
        let storage = Storage()
        
        let testStorageClass = TestStorageClass(value: 42)
        await storage.set(TestStorageClass.self, to: testStorageClass)
        
        let contentOfStorageTestStorageClass = await storage.get(TestStorageClass.self)
        contentOfStorageTestStorageClass?.value = 24
        XCTAssertEqual(contentOfStorageTestStorageClass, testStorageClass)
    }
    
    func testMutationStruct() async throws {
        let storage = Storage()
        
        let testStorageStruct = TestStorageStruct(value: 42)
        await storage.set(TestStorageStruct.self, to: testStorageStruct)
        
        var contentOfStorageTestStorageStruct = await storage.get(TestStorageStruct.self)
        contentOfStorageTestStorageStruct?.value = 24
        XCTAssertEqual(testStorageStruct.value, 42)
        XCTAssertEqual(contentOfStorageTestStorageStruct?.value, 24)
    }
    
    func testStorageKey() async throws {
        let storage = Storage()
        
        let testStorageClass = TestStorageClass(value: 42)
        await storage.set(TestStorageKey.self, to: testStorageClass)
        
        let contentOfStorageTestStorageClass = await storage.get(TestStorageKey.self)
        XCTAssertEqual(contentOfStorageTestStorageClass, testStorageClass)
    }
    
    func testStorageShutdown() async throws {
        let storage = Storage()
        
        let structShutdownExpectation = XCTestExpectation(description: "Struct shutdown callback should be called.")
        let classShutdownExpectation = XCTestExpectation(description: "Class shutdown callback should be called.")
        
        let testStorageStruct = TestStorageStruct(value: 42)
        await storage.set(TestStorageStruct.self, to: testStorageStruct, onShutdown: { _ in
            structShutdownExpectation.fulfill()
            
            struct TestError: Error {}
            throw TestError()
        })
        
        let testStorageClass = TestStorageClass(value: 42)
        await storage.set(TestStorageClass.self, to: testStorageClass, onShutdown: { _ in
            classShutdownExpectation.fulfill()
        })
        
        await storage.shutdown()
        await storage.clear()
        
        wait(for: [structShutdownExpectation, classShutdownExpectation], timeout: 0.1)
        
        let newerContentOfStorageTestStorageStruct = await storage.get(TestStorageStruct.self)
        XCTAssertNil(newerContentOfStorageTestStorageStruct)
    }
}
