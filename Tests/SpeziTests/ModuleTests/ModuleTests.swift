//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(APISupport) @testable import Spezi
import SpeziTesting
import SwiftUI
import Testing


private final class DependingTestModule: Module {
    let confirmation: Confirmation?
    @Dependency var module = TestModule()


    init(confirmation: Confirmation? = nil, dependencyConfirmation: Confirmation? = nil) {
        self.confirmation = confirmation
        self._module = Dependency(wrappedValue: TestModule(confirmation: dependencyConfirmation))
    }


    func configure() {
        self.confirmation?()
    }
}


@MainActor
@Suite("Module", .serialized)
struct ModuleTests {
    @Test("Module Flow")
    func moduleFlow() async {
        await confirmation { confirmation in
            _ = Text("Spezi")
                .spezi(TestApplicationDelegate(confirmation: confirmation))
        }
    }

    @Test("Spezi")
    func spezi() throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [DependingTestModule()])

        let modules = spezi.modules
        #expect(modules.count == 3)
        #expect(modules.contains(where: { $0 is DefaultStandard }))
        #expect(modules.contains(where: { $0 is DependingTestModule }))
        #expect(modules.contains(where: { $0 is TestModule }))
    }

    @Test("Preview Modifier")
    func previewModifier() async throws {
        // manually patch environment variable for running within Xcode preview window
        setenv(ProcessInfo.xcodeRunningForPreviewKey, "1", 1)

        try await confirmation { confirmation in
            _ = try #require(
                Text("Spezi")
                    .previewWith {
                        TestModule(confirmation: confirmation)
                    }
            )
        }

        unsetenv(ProcessInfo.xcodeRunningForPreviewKey)
    }

    @Test("Module Creation")
    func moduleCreation() async {
        await confirmation { moduleConfirmation in
            await confirmation { dependencyConfirmation in
                let module = DependingTestModule(confirmation: moduleConfirmation, dependencyConfirmation: dependencyConfirmation)

                withDependencyResolution {
                    module
                }


                _ = module.module
            }
        }
    }
}
