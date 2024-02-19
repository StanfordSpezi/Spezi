//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI
import XCTestApp


@main
struct UITestsApp: App {
    @ApplicationDelegateAdaptor(TestAppDelegate.self) var appDelegate

    
    var body: some Scene {
        WindowGroup {
            TestAppTestsView<SpeziTests>()
                .spezi(appDelegate)
        }
    }
}
