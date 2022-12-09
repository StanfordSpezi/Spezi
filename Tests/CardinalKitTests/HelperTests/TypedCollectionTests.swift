//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import os
import XCTest


protocol TestTypedCollectionTypes: Equatable {
    var value: Int { get }
}


final class TypedCollectionTests: XCTestCase {
    struct TestTypedCollectionStruct: TypedCollectionKey, TestTypedCollectionTypes {
        typealias Value = Self
        
        var value: Int
    }
    
    class TestTypedCollectionClass: TypedCollectionKey, TestTypedCollectionTypes {
        var value: Int
        
        
        init(value: Int) {
            self.value = value
        }
        
        
        static func == (lhs: TypedCollectionTests.TestTypedCollectionClass, rhs: TypedCollectionTests.TestTypedCollectionClass) -> Bool {
            lhs.value == rhs.value
        }
    }
    
    enum TestTypedCollectionKey: TypedCollectionKey {
        typealias Value = TestTypedCollectionClass
    }
    

    func testSetAndGet() {
        let typedCollection = TypedCollection()
        
        let testTypedCollectionStruct = TestTypedCollectionStruct(value: 42)
        typedCollection[TestTypedCollectionStruct.self] = testTypedCollectionStruct
        
        let contentOfTypedCollectionStruct = typedCollection[TestTypedCollectionStruct.self]
        XCTAssertEqual(contentOfTypedCollectionStruct, testTypedCollectionStruct)
        
        let newTestTypedCollectionStruct = TestTypedCollectionStruct(value: 24)
        typedCollection.set(TestTypedCollectionStruct.self, to: newTestTypedCollectionStruct)
        let newContentOfTypedStruct = typedCollection.get(TestTypedCollectionStruct.self)
        XCTAssertEqual(newContentOfTypedStruct, newTestTypedCollectionStruct)
        
        typedCollection.set(TestTypedCollectionStruct.self, to: nil)
        let newerContentOfTypedStruct = typedCollection.get(TestTypedCollectionStruct.self)
        XCTAssertNil(newerContentOfTypedStruct)
    }
    
    func testGetWithDefault() {
        let typedCollection = TypedCollection()
        
        let testTypedCollectionStruct = TestTypedCollectionStruct(value: 42)
        
        let contentOfTypedStruct = typedCollection.get(TestTypedCollectionStruct.self, default: testTypedCollectionStruct)
        XCTAssertEqual(contentOfTypedStruct, testTypedCollectionStruct)
    }
    
    func testContains() {
        let typedCollection = TypedCollection()
        
        let testTypedCollectionStruct = TestTypedCollectionStruct(value: 42)
        let shouldNotContainTestStruct = typedCollection.contains(TestTypedCollectionStruct.self)
        XCTAssertFalse(shouldNotContainTestStruct)
        
        typedCollection.set(TestTypedCollectionStruct.self, to: testTypedCollectionStruct)
        let shouldContainTestStruct = typedCollection.contains(TestTypedCollectionStruct.self)
        XCTAssertTrue(shouldContainTestStruct)
        
        typedCollection.set(TestTypedCollectionStruct.self, to: nil)
        let shouldNotContainTestStructAgain = typedCollection.contains(TestTypedCollectionStruct.self)
        XCTAssertFalse(shouldNotContainTestStructAgain)
    }
    
    func testGetAllThatConformTo() {
        let typedCollection = TypedCollection()
        
        let testTypedCollectionStruct = TestTypedCollectionStruct(value: 42)
        typedCollection.set(TestTypedCollectionStruct.self, to: testTypedCollectionStruct)
        let testTypedCollectionClass = TestTypedCollectionClass(value: 42)
        typedCollection.set(TestTypedCollectionClass.self, to: testTypedCollectionClass)
        
        let testTypedCollectionTypes = typedCollection.get(allThatConformTo: (any TestTypedCollectionTypes).self)
        XCTAssertEqual(testTypedCollectionTypes.count, 2)
        for testTypedCollectionType in testTypedCollectionTypes {
            XCTAssertEqual(testTypedCollectionType.value, 42)
        }
    }
    
    func testClear() {
        let typedCollection = TypedCollection()
        
        let testTypedCollectionStruct = TestTypedCollectionStruct(value: 42)
        typedCollection.set(TestTypedCollectionStruct.self, to: testTypedCollectionStruct)
        
        typedCollection.clear()
        
        let newerContentOfTypedStruct = typedCollection.get(TestTypedCollectionStruct.self)
        XCTAssertNil(newerContentOfTypedStruct)
    }
    
    func testMutationClass() {
        let typedCollection = TypedCollection()
        
        let testTypedCollectionClass = TestTypedCollectionClass(value: 42)
        typedCollection.set(TestTypedCollectionClass.self, to: testTypedCollectionClass)
        
        let contentOfTypedClass = typedCollection.get(TestTypedCollectionClass.self)
        contentOfTypedClass?.value = 24
        XCTAssertEqual(contentOfTypedClass, testTypedCollectionClass)
    }
    
    func testMutationStruct() {
        let typedCollection = TypedCollection()
        
        let testTypedCollectionStruct = TestTypedCollectionStruct(value: 42)
        typedCollection.set(TestTypedCollectionStruct.self, to: testTypedCollectionStruct)
        
        var contentOfTypedStruct = typedCollection.get(TestTypedCollectionStruct.self)
        contentOfTypedStruct?.value = 24
        XCTAssertEqual(testTypedCollectionStruct.value, 42)
        XCTAssertEqual(contentOfTypedStruct?.value, 24)
    }
    
    func testTypedCollectionKey() {
        let typedCollection = TypedCollection()
        
        let testTypedCollectionClass = TestTypedCollectionClass(value: 42)
        typedCollection.set(TestTypedCollectionKey.self, to: testTypedCollectionClass)
        
        let contentOfTypedClass = typedCollection.get(TestTypedCollectionKey.self)
        XCTAssertEqual(contentOfTypedClass, testTypedCollectionClass)
    }
    
    func testTypedCollectionShutdown() {
        let typedCollection = TypedCollection()
        
        let structShutdownExpectation = XCTestExpectation(description: "Struct shutdown callback should be called.")
        let classShutdownExpectation = XCTestExpectation(description: "Class shutdown callback should be called.")
        
        let testTypedCollectionStruct = TestTypedCollectionStruct(value: 42)
        typedCollection.set(TestTypedCollectionStruct.self, to: testTypedCollectionStruct, onShutdown: { _ in
            structShutdownExpectation.fulfill()
            
            struct TestError: Error {}
            throw TestError()
        })
        
        let testTypedCollectionClass = TestTypedCollectionClass(value: 42)
        typedCollection.set(TestTypedCollectionClass.self, to: testTypedCollectionClass, onShutdown: { _ in
            classShutdownExpectation.fulfill()
        })
        
        typedCollection.shutdown()
        typedCollection.clear()
        
        wait(for: [structShutdownExpectation, classShutdownExpectation])
        
        let newerContentOfTypedStruct = typedCollection.get(TestTypedCollectionStruct.self)
        XCTAssertNil(newerContentOfTypedStruct)
    }
}
