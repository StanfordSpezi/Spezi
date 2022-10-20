//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


struct ExampleAppStandard: Standard {}


// swiftlint:disable:next generic_type_name
class ExampleAppComponent<ResourceRepresentation: Standard>: Component, LifecycleHandler, ObservableObjectComponent, ObservableObject, StorageKey {
    var greeting: String
    
    
    init(greeting: String) {
        self.greeting = greeting
    }
}


class ExampleAppDelegate: CardinalKitAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: ExampleAppStandard()) {
            ExampleAppComponent(greeting: "Hello, Paul!")
        }
    }
}


@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor(ExampleAppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .cardinalKit(appDelegate)
        }
    }
}
