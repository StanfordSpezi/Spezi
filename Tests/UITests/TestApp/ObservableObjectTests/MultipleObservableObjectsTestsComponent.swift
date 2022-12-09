//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


final class MultipleObservableObjectsTestsComponent<ComponentStandard: Standard>: Module {
    class TestObservableObject<T>: ObservableObject {
        let value: T
        
        
        init(value: T) {
            self.value = value
        }
    }
    
    
    var observableObjects: [any ObservableObject] {
        [
            TestObservableObject(value: 42),
            TestObservableObject(value: "42")
        ]
    }
}
