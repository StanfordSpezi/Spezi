//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import SwiftUI
import Testing


@MainActor
@Suite("ViewModifier", .serialized)
struct ViewModifierTests {
    @Test("ViewModifier Retrieval")
    func viewModifierRetrieval() async {
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

    @Test
    func emptyRetrieval() {
        let speziAppDelegate = SpeziAppDelegate()
        #expect(speziAppDelegate.spezi.viewModifiers.isEmpty)
    }
}
