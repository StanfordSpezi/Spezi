//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
@testable import Spezi
import SpeziTesting
import Testing


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


@Suite("Module Communication", .serialized)
struct ModuleCommunicationTests {
    private final class TestApplicationDelegate: SpeziAppDelegate {
        override var configuration: Configuration {
            Configuration {
                provideModule
                collectModule
            }
        }
    }

    @MainActor private static var provideModule = ProvideModule1()
    @MainActor private static var collectModule = CollectModule()


    @MainActor
    init() async throws {
        Self.provideModule = ProvideModule1()
        Self.collectModule = CollectModule()
    }

    @MainActor
    @Test("Simple Communication")
    func testSimpleCommunication() throws {
        let delegate = TestApplicationDelegate()
        _ = delegate.spezi // ensure init

        #expect(Self.collectModule.nums == [2, 3, 4, 5, 6])
        #expect(Self.collectModule.nothingProvided.isEmpty)
        #expect(Self.collectModule.strings == ["Hello World"])
    }
}
