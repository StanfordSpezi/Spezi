//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
@testable import Spezi
import XCTest

struct TestAnchor: RepositoryAnchor {}

protocol TestTypes: Equatable {
    typealias Anchor = TestAnchor // default anchor

    var value: Int { get }
}

private protocol AnyTestInstance {
    func testSetAndGet()

    func testGetWithDefault()

    func testContains()

    func testGetAllThatConformTo()

    func testMutationClass()

    func testMutationStruct()

    func testKeyLikeKnowledgeSource()
}


final class SharedRepositoryTests: XCTestCase {
    struct TestStruct: KnowledgeSource, TestTypes {
        var value: Int
    }
    
    class TestClass: KnowledgeSource, TestTypes {
        var value: Int

        
        init(value: Int) {
            self.value = value
        }
        
        
        static func == (lhs: SharedRepositoryTests.TestClass, rhs: SharedRepositoryTests.TestClass) -> Bool {
            lhs.value == rhs.value
        }
    }
    
    enum TestKeyLike: KnowledgeSource {
        typealias Anchor = TestAnchor
        typealias Value = TestClass
    }

    struct DefaultedTestStruct: DefaultProvidingKnowledgeSource, TestTypes {
        var value: Int
        static let defaultValue = DefaultedTestStruct(value: 0)
    }
    

    class TestInstance<Repository: SharedRepository>: AnyTestInstance where Repository.Anchor == TestAnchor {
        var repository: Repository

        init(_ repository: Repository) {
            self.repository = repository
        }

        func testSetAndGet() {
            // test basic insertion and retrieval
            let testStruct = TestStruct(value: 42)
            repository[TestStruct.self] = testStruct
            let contentOfStruct = repository[TestStruct.self]
            XCTAssertEqual(contentOfStruct, testStruct)

            // test overwrite and retrieval
            let newTestStruct = TestStruct(value: 24)
            repository[TestStruct.self] = newTestStruct
            let newContentOfStruct = repository[TestStruct.self]
            XCTAssertEqual(newContentOfStruct, newTestStruct)

            // test deletion
            repository[TestStruct.self] = nil
            let newerContentOfStruct = repository[TestStruct.self]
            XCTAssertNil(newerContentOfStruct)
        }

        func testGetWithDefault() {
            let testStruct = DefaultedTestStruct(value: 42)

            // test global default
            let defaultStruct = repository[DefaultedTestStruct.self]
            XCTAssertEqual(defaultStruct, DefaultedTestStruct(value: 0))

            // test that it falls back to the regular KnowledgeSource subscript if expecting a optional type
            let regularSubscript = repository[DefaultedTestStruct.self] ?? testStruct
            XCTAssertEqual(regularSubscript, testStruct)
        }

        func testContains() {
            let testStruct = TestStruct(value: 42)
            XCTAssertFalse(repository.contains(TestStruct.self))

            repository[TestStruct.self] = testStruct
            XCTAssertTrue(repository.contains(TestStruct.self))

            repository[TestStruct.self] = nil
            XCTAssertFalse(repository.contains(TestStruct.self))
        }

        func testGetAllThatConformTo() {
            let testStruct = TestStruct(value: 42)
            repository[TestStruct.self] = testStruct
            let testClass = TestClass(value: 42)
            repository[TestClass.self] = testClass

            let testTypes = repository.collect(allOf: (any TestTypes).self)
            XCTAssertEqual(testTypes.count, 2)
            XCTAssertTrue(testTypes.allSatisfy { $0.value == 42 })
        }

        func testMutationClass() {
            let testClass = TestClass(value: 42)
            repository[TestClass.self] = testClass

            let contentOfClass = repository[TestClass.self]
            contentOfClass?.value = 24
            XCTAssertEqual(contentOfClass, testClass)
        }

        func testMutationStruct() {
            let testStruct = TestStruct(value: 42)
            repository[TestStruct.self] = testStruct

            var contentOfStruct = repository[TestStruct.self]
            contentOfStruct?.value = 24
            XCTAssertEqual(testStruct.value, 42)
            XCTAssertEqual(contentOfStruct?.value, 24)
        }

        func testKeyLikeKnowledgeSource() {
            let testClass = TestClass(value: 42)
            repository[TestKeyLike.self] = testClass

            let contentOfClass = repository[TestKeyLike.self]
            XCTAssertEqual(contentOfClass, testClass)
        }
    }

    private var repos: [AnyTestInstance] = [TestInstance(HeapRepository<TestAnchor>()), TestInstance(ValueRepository<TestAnchor>())]

    func testSetAndGet() {
        repos.forEach { $0.testSetAndGet() }
    }

    func testGetWithDefault() {
        repos.forEach { $0.testGetWithDefault() }
    }

    func testContains() {
        repos.forEach { $0.testContains() }
    }

    func testGetAllThatConformTo() {
        repos.forEach { $0.testGetAllThatConformTo() }
    }

    func testMutationClass() {
        repos.forEach { $0.testMutationClass() }
    }

    func testMutationStruct() {
        repos.forEach { $0.testMutationStruct() }
    }

    func testKeyLikeKnowledgeSource() {
        repos.forEach { $0.testKeyLikeKnowledgeSource() }
    }
}
