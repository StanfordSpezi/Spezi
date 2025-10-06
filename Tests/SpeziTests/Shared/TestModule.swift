//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI
import Testing
import XCTest


struct TestViewModifier: ViewModifier {
    let message: String

    func body(content: Content) -> some View {
        content
    }
}


final class TestModule: Module {
    let confirmation: Confirmation?
    let expectation: XCTestExpectation

    @Modifier var modifier1 = TestViewModifier(message: "Hello")
    @Modifier var modifier2 = TestViewModifier(message: "World")

    
    init(confirmation: Confirmation? = nil, expectation: XCTestExpectation = XCTestExpectation()) {
        self.confirmation = confirmation
        self.expectation = expectation
    }
    
    
    func configure() {
        expectation.fulfill()
        confirmation?()
    }
}
