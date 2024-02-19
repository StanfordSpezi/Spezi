//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import XCTest
import XCTRuntimeAssertions
import XCTSpezi


private final class ProvideModule1: Module {
    @Provide var num: Int = 2
    @Provide var numMaybe: Int? = 3
    @Provide var numMaybe2: Int?
    @Provide var numArray: [Int] = []

    @Provide var noCollect: Float = 1

    @Provide var someString: String = "Hello Module"

    init() {
        someString = "Hello World"

        if numArray.isEmpty {
            numArray.append(contentsOf: [4, 5, 6])
        }
    }
}


private final class CollectModule: Module {
    @Collect var nums: [Int]
    @Collect var strings: [String]

    @Collect var nothingProvided: [UUID]
}


final class ModuleCommunicationTests: XCTestCase {
    private class TestApplicationDelegate: SpeziAppDelegate {
        override var configuration: Configuration {
            Configuration {
                provideModule
                collectModule
            }
        }
    }

    private static var provideModule = ProvideModule1()
    private static var collectModule = CollectModule()


    override func setUp() {
        Self.provideModule = ProvideModule1()
        Self.collectModule = CollectModule()
    }

    func testSimpleCommunication() throws {
        let delegate = TestApplicationDelegate()
        _ = delegate.spezi // ensure init

        XCTAssertEqual(Self.collectModule.nums, [2, 3, 4, 5, 6])
        XCTAssertTrue(Self.collectModule.nothingProvided.isEmpty)
        XCTAssertEqual(Self.collectModule.strings, ["Hello World"])
    }

    func testIllegalAccess() throws {
        let delegate = TestApplicationDelegate()

        try XCTRuntimePrecondition {
            _ = Self.collectModule.strings
        }

        _ = delegate.spezi // ensure init

        try XCTRuntimePrecondition {
            Self.provideModule.numMaybe2 = 12
        }
    }
}
