//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import XCTest


struct TestComponent<S: Standard>: Component, Equatable {
    typealias ResourceRepresentation = S
    
    let expectation: XCTestExpectation
    
    
    func configure(cardinalKit: CardinalKit<ResourceRepresentation>) {
        expectation.fulfill()
    }
}
