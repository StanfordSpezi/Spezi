//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if DEBUG
import CardinalKit
import SwiftUI
@_exported import XCTest


public class TestApplicationDelegate: CardinalKitAppDelegate {
    let expectation: XCTestExpectation
    
    
    override public var configuration: Configuration {
        Configuration(standard: MockStandard()) {
            TestComponent(expectation: expectation)
        }
    }
    
    
    public init(expectation: XCTestExpectation) {
        self.expectation = expectation
        super.init()
    }
}
#endif
