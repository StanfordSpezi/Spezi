//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import XCTestApp


enum SpeziTests: String, TestAppTests {
    case viewModifier = "ViewModifier"
    case lifecycleHandler = "LifecycleHandler"
    case model = "Model"
    
    
    func view(withNavigationPath path: Binding<NavigationPath>) -> some View {
        switch self {
        case .viewModifier:
            ViewModifierTestView()
        case .lifecycleHandler:
            LifecycleHandlerTestsView()
        case .model:
            ModelTestView()
        }
    }
}
