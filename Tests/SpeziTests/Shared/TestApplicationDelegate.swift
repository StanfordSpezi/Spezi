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


class TestApplicationDelegate: SpeziAppDelegate {
    let confirmation: Confirmation?
    let expectation: XCTestExpectation
    
    
    override var configuration: Configuration {
        Configuration {
            TestModule(confirmation: confirmation, expectation: expectation)
        }
    }


    init(expectation: XCTestExpectation) {
        self.confirmation = nil
        self.expectation = expectation
        super.init()
    }

    init(confirmation: Confirmation) {
        self.confirmation = confirmation
        self.expectation = .init()
        super.init()
    }
}
