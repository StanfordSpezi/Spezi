//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI
import XCTest


struct TestComponent<S: Standard>: Component, ObservableObjectComponent, StorageKey, Equatable {
    typealias ResourceRepresentation = S
    
    
    class TestObservableObject: ObservableObject {}
    
    
    let expectation: XCTestExpectation
    
    
    var observableObject: TestObservableObject {
        TestObservableObject()
    }
    
    
    func configure(cardinalKit: CardinalKit<ResourceRepresentation>) {
        cardinalKit.storage.set(TestComponent.self, to: self)
        expectation.fulfill()
    }
}
