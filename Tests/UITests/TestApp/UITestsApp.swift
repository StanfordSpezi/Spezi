//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


@main
struct UITestsApp: App {
    @UIApplicationDelegateAdaptor(UITestsAppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Text("UITestsApp")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                ObservableObjectTestsView()
                    .tabItem {
                        Label("ObservableObjectTests", systemImage: "eyeglasses")
                    }
                SecureStorageTestsView()
                    .tabItem {
                        Label("SecureStorageTests", systemImage: "lock")
                    }
            }
                .cardinalKit(appDelegate)
        }
    }
}
