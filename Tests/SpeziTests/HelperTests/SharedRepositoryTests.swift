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

    func testComputedKnowledgeSourceComputedOnlyPolicy()

    func testComputedKnowledgeSourceComputedOnlyPolicyReadOnly()

    func testComputedKnowledgeSourceStorePolicy()
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

    struct ComputedTestStruct<Policy: ComputedKnowledgeSourceStoragePolicy>: ComputedKnowledgeSource {
        typealias Anchor = TestAnchor
        typealias Value = Int
        typealias StoragePolicy = Policy

        static func compute<Repository: SharedRepository<Anchor>>(from repository: Repository) -> Int {
            computedValue
        }
    }

    struct OptionalComputedTestStruct<Policy: ComputedKnowledgeSourceStoragePolicy>: OptionalComputedKnowledgeSource {
        typealias Anchor = TestAnchor
        typealias Value = Int
        typealias StoragePolicy = Policy

        static func compute<Repository: SharedRepository<Anchor>>(from repository: Repository) -> Int? {
            optionalComputedValue
        }
    }
    

    class TestInstance<Repository: SharedRepository>: AnyTestInstance where Repository.Anchor == TestAnchor {
        var repository: Repository

        var readRepository: Repository {
            repository
        }

        init(_ repository: Repository) {
            self.repository = repository
        }

        func testSetAndGet() {
            // test basic insertion and retrieval
            let testStruct = TestStruct(value: 42)
            repository[TestStruct.self] = testStruct
            let contentOfStruct = readRepository[TestStruct.self]
            XCTAssertEqual(contentOfStruct, testStruct)

            // test overwrite and retrieval
            let newTestStruct = TestStruct(value: 24)
            repository[TestStruct.self] = newTestStruct
            let newContentOfStruct = readRepository[TestStruct.self]
            XCTAssertEqual(newContentOfStruct, newTestStruct)

            // test deletion
            repository[TestStruct.self] = nil
            let newerContentOfStruct = readRepository[TestStruct.self]
            XCTAssertNil(newerContentOfStruct)
        }

        func testGetWithDefault() {
            let testStruct = DefaultedTestStruct(value: 42)

            // test global default
            let defaultStruct = readRepository[DefaultedTestStruct.self]
            XCTAssertEqual(defaultStruct, DefaultedTestStruct(value: 0))

            // test that it falls back to the regular KnowledgeSource subscript if expecting a optional type
            let regularSubscript = readRepository[DefaultedTestStruct.self] ?? testStruct
            XCTAssertEqual(regularSubscript, testStruct)
        }

        func testContains() {
            let testStruct = TestStruct(value: 42)
            XCTAssertFalse(readRepository.contains(TestStruct.self))

            repository[TestStruct.self] = testStruct
            XCTAssertTrue(readRepository.contains(TestStruct.self))

            repository[TestStruct.self] = nil
            XCTAssertFalse(readRepository.contains(TestStruct.self))
        }

        func testGetAllThatConformTo() {
            let testStruct = TestStruct(value: 42)
            repository[TestStruct.self] = testStruct
            let testClass = TestClass(value: 42)
            repository[TestClass.self] = testClass

            let testTypes = readRepository.collect(allOf: (any TestTypes).self)
            XCTAssertEqual(testTypes.count, 2)
            XCTAssertTrue(testTypes.allSatisfy { $0.value == 42 })
        }

        func testMutationClass() {
            let testClass = TestClass(value: 42)
            repository[TestClass.self] = testClass

            let contentOfClass = readRepository[TestClass.self]
            contentOfClass?.value = 24
            XCTAssertEqual(contentOfClass, testClass)
        }

        func testMutationStruct() {
            let testStruct = TestStruct(value: 42)
            repository[TestStruct.self] = testStruct

            var contentOfStruct = readRepository[TestStruct.self]
            contentOfStruct?.value = 24
            XCTAssertEqual(testStruct.value, 42)
            XCTAssertEqual(contentOfStruct?.value, 24)
        }

        func testKeyLikeKnowledgeSource() {
            let testClass = TestClass(value: 42)
            repository[TestKeyLike.self] = testClass

            let contentOfClass = readRepository[TestKeyLike.self]
            XCTAssertEqual(contentOfClass, testClass)
        }

        func testComputedKnowledgeSourceComputedOnlyPolicy() {
            let value = repository[ComputedTestStruct<_AlwaysComputePolicy>.self]
            let optionalValue = repository[OptionalComputedTestStruct<_AlwaysComputePolicy>.self]

            XCTAssertEqual(value, computedValue)
            XCTAssertEqual(optionalValue, optionalComputedValue)

            // make sure computed knowledge sources with `AlwaysCompute` policy are re-computed
            computedValue = 5
            optionalComputedValue = 4

            let newValue = repository[ComputedTestStruct<_AlwaysComputePolicy>.self]
            let newOptionalValue = repository[OptionalComputedTestStruct<_AlwaysComputePolicy>.self]

            XCTAssertEqual(newValue, computedValue)
            XCTAssertEqual(newOptionalValue, optionalComputedValue)
        }

        func testComputedKnowledgeSourceComputedOnlyPolicyReadOnly() {
            let repository = repository // read-only

            let value = repository[ComputedTestStruct<_AlwaysComputePolicy>.self]
            let optionalValue = repository[OptionalComputedTestStruct<_AlwaysComputePolicy>.self]

            XCTAssertEqual(value, computedValue)
            XCTAssertEqual(optionalValue, optionalComputedValue)

            // make sure computed knowledge sources with `AlwaysCompute` policy are re-computed
            computedValue = 5
            optionalComputedValue = 4

            let newValue = repository[ComputedTestStruct<_AlwaysComputePolicy>.self]
            let newOptionalValue = repository[OptionalComputedTestStruct<_AlwaysComputePolicy>.self]

            XCTAssertEqual(newValue, computedValue)
            XCTAssertEqual(newOptionalValue, optionalComputedValue)
        }

        func testComputedKnowledgeSourceStorePolicy() {
            let value = repository[ComputedTestStruct<_StoreComputePolicy>.self]
            let optionalValue = repository[OptionalComputedTestStruct<_StoreComputePolicy>.self]

            XCTAssertEqual(value, computedValue)
            XCTAssertEqual(optionalValue, optionalComputedValue)

            // get call bypasses the compute call, so tests if it's really stored
            let getValue = repository.get(ComputedTestStruct<_StoreComputePolicy>.self)
            let getOptionalValue = repository.get(OptionalComputedTestStruct<_StoreComputePolicy>.self)

            XCTAssertEqual(getValue, computedValue)
            XCTAssertEqual(getOptionalValue, optionalComputedValue) // this is nil

            // make sure computed knowledge sources with `Store` policy are not re-computed
            computedValue = 5
            optionalComputedValue = 4

            let newValue = repository[ComputedTestStruct<_StoreComputePolicy>.self]
            let newOptionalValue = repository[OptionalComputedTestStruct<_StoreComputePolicy>.self]

            XCTAssertEqual(newValue, value)
            XCTAssertEqual(newOptionalValue, optionalComputedValue) // never stored as it was nil

            // last check if its really written now
            let writtenOptionalValue = repository.get(OptionalComputedTestStruct<_StoreComputePolicy>.self)
            XCTAssertEqual(writtenOptionalValue, optionalComputedValue)

            // check again that it doesn't change
            optionalComputedValue = nil
            XCTAssertEqual(repository[OptionalComputedTestStruct<_StoreComputePolicy>.self], 4)
        }
    }

    static var computedValue: Int = 3
    static var optionalComputedValue: Int?

    private var repos: [AnyTestInstance] = []

    override func setUp() {
        repos = [TestInstance(HeapRepository<TestAnchor>()), TestInstance(ValueRepository<TestAnchor>())]
        Self.computedValue = 3
        Self.optionalComputedValue = nil
    }

    func testValueRepositoryIteration() {
        var repository = ValueRepository<TestAnchor>()
        repository[TestStruct.self] = TestStruct(value: 3)
        iterationTest(repository)
    }

    func testHeapRepositoryIteration() {
        var repository = HeapRepository<TestAnchor>()
        repository[TestStruct.self] = TestStruct(value: 3)
        iterationTest(repository)
    }

    func iterationTest<Repository: SharedRepository<TestAnchor>>(_ repository: Repository)
        where Repository: Collection, Repository.Element == AnyRepositoryValue {
        for value in repository {
            XCTAssertTrue(value.anySource is TestStruct.Type)
            XCTAssertTrue(value.anyValue is TestStruct)
            XCTAssertEqual(value.anyValue as? TestStruct, TestStruct(value: 3))
        }
    }

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

    func testComputedKnowledgeSourceComputedOnlyPolicy() {
        repos.forEach { $0.testComputedKnowledgeSourceComputedOnlyPolicy() }
    }

    func testComputedKnowledgeSourceComputedOnlyPolicyReadOnly() {
        repos.forEach { $0.testComputedKnowledgeSourceComputedOnlyPolicyReadOnly() }
    }

    func testComputedKnowledgeSourceStorePolicy() {
        repos.forEach { $0.testComputedKnowledgeSourceStorePolicy() }
    }
}
