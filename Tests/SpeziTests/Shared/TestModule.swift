//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
#if canImport(SwiftUI)
import SwiftUI
#endif
import Testing

#if canImport(SwiftUI)
struct TestViewModifier: ViewModifier {
    let message: String

    func body(content: Content) -> some View {
        content
    }
}
#endif


final class TestModule: Module {
    let confirmation: Confirmation?
    let expectation: TestExpectation?
    
#if canImport(SwiftUI)
    @Modifier var modifier1 = TestViewModifier(message: "Hello")
    @Modifier var modifier2 = TestViewModifier(message: "World")
#endif

    
    init(confirmation: Confirmation? = nil, expectation: TestExpectation? = nil) {
        self.confirmation = confirmation
        self.expectation = expectation
    }
    
    
    func configure() {
        expectation?.fulfill()
        confirmation?()
    }
}
