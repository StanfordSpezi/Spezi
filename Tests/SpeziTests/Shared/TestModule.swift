//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI
@_exported import XCTest

struct TestViewModifier: ViewModifier {
    let message: String

    func body(content: Content) -> some View {
        content
    }
}

public final class TestModule: Module {
    let expectation: XCTestExpectation

    @Modifier var modifier1 = TestViewModifier(message: "Hello")
    @Modifier var modifier2 = TestViewModifier(message: "World")

    
    public init(expectation: XCTestExpectation = XCTestExpectation()) {
        self.expectation = expectation
    }
    
    
    public func configure() {
        expectation.fulfill()
    }
}
