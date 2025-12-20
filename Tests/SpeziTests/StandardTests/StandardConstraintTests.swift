//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable file_types_order

#if canImport(SwiftUI)
@_spi(APISupport)
@testable import Spezi
import SpeziTesting
import Testing


@MainActor
@Suite
struct StandardConstraintTests {
    @Test
    func unconstrainedStandardInjection() async throws {
        let standard = TestStandardNoConstraint()
        let appDelegate = TestAppDelegate(standard: standard) {
            TestModule0()
        }
        let spezi = appDelegate.spezi
        let module = try #require(spezi.module(TestModule0.self))
        #expect(module.standardExplicitType === standard)
        #expect(module.standardNoType === standard)
    }
    
    
    @Test
    func constrainedStandardInjectionConstraintPresent() async throws {
        let standard = TestStandardWithConstraint()
        let appDelegate = TestAppDelegate(standard: standard) {
            TestModule1()
        }
        let spezi = appDelegate.spezi
        let module = try #require(spezi.module(TestModule1.self))
        #expect(module.standard === standard)
    }
    
    @Test
    func constrainedStandardInjectionConstraintNotPresent() async throws {
        let standard = TestStandardNoConstraint()
        let appDelegate = TestAppDelegate(standard: standard) {
            TestModule1()
        }
        let spezi = appDelegate.spezi
        let module = try #require(spezi.module(TestModule1.self))
        #expect(module.standard === nil)
    }
}


// MARK: Supporting Spezi Components

private protocol ExampleConstraint: Standard {}

private actor TestStandardNoConstraint: Standard {}
private actor TestStandardWithConstraint: Standard, ExampleConstraint {}


private final class TestModule0: Module {
    @StandardActor var standardExplicitType: any Standard
    @StandardActor var standardNoType
}


private final class TestModule1: Module {
    @StandardActor var standard: (any ExampleConstraint)?
}


private final class TestAppDelegate<S: Standard>: SpeziAppDelegate {
    private let standard: S
    private let modules: ModuleCollection
    
    override var configuration: Configuration {
        Configuration(standard: standard) {
            modules
        }
    }
    
    init(standard: S, @ModuleBuilder modules: () -> ModuleCollection) {
        self.standard = standard
        self.modules = modules()
    }
}

#endif
