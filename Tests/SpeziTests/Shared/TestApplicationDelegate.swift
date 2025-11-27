//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if canImport(SwiftUI)
import Spezi
import SwiftUI
import Testing


class TestApplicationDelegate: SpeziAppDelegate {
    let confirmation: Confirmation?
    let expectation: TestExpectation?
    
    
    override var configuration: Configuration {
        Configuration {
            TestModule(confirmation: confirmation, expectation: expectation)
        }
    }


    init(expectation: TestExpectation) {
        self.confirmation = nil
        self.expectation = expectation
        super.init()
    }

    init(confirmation: Confirmation) {
        self.confirmation = confirmation
        self.expectation = nil
        super.init()
    }
}
#endif
