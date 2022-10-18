//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor(CardinalKitAppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .cardinalKit(appDelegate)
        }
    }
}
