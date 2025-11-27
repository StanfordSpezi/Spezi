//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if canImport(SwiftUI)
@testable import Spezi
import SwiftUI
import Testing


@Suite("ViewModifier")
struct ViewModifierTests {
    @MainActor
    @Test("ViewModifier Retrieval")
    func testViewModifierRetrieval() async {
        await confirmation { confirmation in
            let testApplicationDelegate = TestApplicationDelegate(confirmation: confirmation)

            let modifiers = testApplicationDelegate.spezi.viewModifiers
            #expect(modifiers.count == 2)

            let message = modifiers
                .compactMap { $0 as? TestViewModifier }
                .map { $0.message }
                .joined(separator: " ")
            #expect(message == "Hello World")
        }
    }

    @MainActor
    func testEmptyRetrieval() {
        let speziAppDelegate = SpeziAppDelegate()
        #expect(speziAppDelegate.spezi.viewModifiers.isEmpty)
    }
}
#endif
