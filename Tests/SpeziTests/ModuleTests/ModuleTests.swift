//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(Spezi) @testable import Spezi
import SwiftUI
import XCTest
import XCTRuntimeAssertions
import XCTSpezi


private final class DependingTestModule: Module {
    let expectation: XCTestExpectation
    @Dependency var module = TestModule()


    init(expectation: XCTestExpectation = XCTestExpectation(), dependencyExpectation: XCTestExpectation = XCTestExpectation()) {
        self.expectation = expectation
        self._module = Dependency(wrappedValue: TestModule(expectation: dependencyExpectation))
    }


    func configure() {
        self.expectation.fulfill()
    }
}


final class ModuleTests: XCTestCase {
    @MainActor
    func testModuleFlow() throws {
        let expectation = XCTestExpectation(description: "Module")
        expectation.assertForOverFulfill = true

        _ = Text("Spezi")
            .spezi(TestApplicationDelegate(expectation: expectation))

        wait(for: [expectation])
    }

    @MainActor
    func testSpezi() throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [DependingTestModule()])

        let modules = spezi.modules
        XCTAssertEqual(modules.count, 3)
        XCTAssert(modules.contains(where: { $0 is DefaultStandard }))
        XCTAssert(modules.contains(where: { $0 is DependingTestModule }))
        XCTAssert(modules.contains(where: { $0 is TestModule }))
    }

    @MainActor
    func testPreviewModifier() throws {
        let expectation = XCTestExpectation(description: "Preview Module")
        expectation.assertForOverFulfill = true

        // manually patch environment variable for running within Xcode preview window
        setenv(ProcessInfo.xcodeRunningForPreviewKey, "1", 1)

        _ = try XCTUnwrap(
            Text("Spezi")
                .previewWith {
                    TestModule(expectation: expectation)
                }
        )
        wait(for: [expectation])

        unsetenv(ProcessInfo.xcodeRunningForPreviewKey)
    }

    @MainActor
    func testModuleCreation() {
        let expectation = XCTestExpectation(description: "DependingTestModule")
        expectation.assertForOverFulfill = true
        let dependencyExpectation = XCTestExpectation(description: "TestModule")
        dependencyExpectation.assertForOverFulfill = true

        let module = DependingTestModule(expectation: expectation, dependencyExpectation: dependencyExpectation)

        withDependencyResolution {
            module
        }

        wait(for: [expectation, dependencyExpectation])

        _ = module.module
    }
}
