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


class ExampleAppComponent: Component, LifecycleHandler, ObservableObjectComponent, ObservableObject {
    var greeting: String
    
    
    init(greeting: String) {
        self.greeting = greeting
    }
    
    
    func configure(cardinalKit: CardinalKit<ExampleAppStandard>) {
        cardinalKit.logger.debug("Configuration called")
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
