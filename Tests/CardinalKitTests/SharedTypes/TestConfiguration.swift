//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import XCTest


struct TestConfiguration: Configuration, Equatable {
    let expectation: XCTestExpectation
    
    
    func configure(_ cardinalKit: CardinalKit) {
        expectation.fulfill()
    }
}
