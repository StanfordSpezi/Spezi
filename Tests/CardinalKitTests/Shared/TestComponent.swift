//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI
@_exported import XCTest


public final class TestComponent<ComponentStandard: Standard>: ObservableObject, Component, ObservableObjectProvider {
    let expectation: XCTestExpectation
    
    
    public init(expectation: XCTestExpectation = XCTestExpectation()) {
        self.expectation = expectation
    }
    
    
    public func configure() {
        expectation.fulfill()
    }
}
