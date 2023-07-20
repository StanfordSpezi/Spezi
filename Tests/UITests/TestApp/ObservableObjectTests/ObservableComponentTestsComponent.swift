//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI


final class ObservableComponentTestsComponent: Module {
    var message: String
    
    
    init(message: String) {
        self.message = message
    }
}
