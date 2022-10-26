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


struct TestComponent<S: Standard>: Component, ObservableObjectComponent, TypedCollectionKey, Equatable {
    typealias ComponentStandard = S
    
    
    class TestObservableObject: ObservableObject {}
    
    
    let expectation: XCTestExpectation
    
    
    var observableObject: TestObservableObject {
        TestObservableObject()
    }
    
    
    func configure(cardinalKit: CardinalKit<ComponentStandard>) {
        cardinalKit.typedCollection.set(TestComponent.self, to: self)
        expectation.fulfill()
    }
}
