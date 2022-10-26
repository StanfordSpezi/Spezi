//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit


class ObservableComponentTestsComponent<ComponentStandard: Standard>: Module {
    var greeting: String
    
    
    init(greeting: String) {
        self.greeting = greeting
    }
}
