# Initial Setup

<!--
                  
This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

The Spezi framework can be integrated into any iOS application. You can define which modules you want to integrate into the Spezi configuration.

## 1. Add the Spezi View Modifier

Set up the Spezi framework in your `App` instance of your SwiftUI application using the ``SpeziAppDelegate`` and the `@UIApplicationDelegateAdaptor` property wrapper.
Use the `View.spezi(_: SpeziAppDelegate)` view modifier to apply your Spezi configuration to the main view in your SwiftUI `Scene`:
```swift
import Spezi
import SwiftUI


@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor(SpeziAppDelegate.self) var appDelegate


    var body: some Scene {
        WindowGroup {
            ContentView()
                .spezi(appDelegate)
        }
    }
}
```


## 2. Modify Your Spezi Configuration

A ``Configuration`` defines the ``Standard`` and ``Component``s that are used in a Spezi project.

Ensure that your standard conforms to all protocols enforced by the ``Component``s. If your ``Component``s require protocol conformances
you must add them to your custom type conforming to ``Standard`` and passed to the initializer or extend a prebuilt standard.

Use ``Configuration/init(_:)`` to use default empty standard instance only conforming to ``Standard`` if you do not use any ``Component`` requiring custom protocol conformances.


The following example demonstrates the usage of an `ExampleStandard` standard and reusable Spezi modules, including the `HealthKit` and `QuestionnaireDataSource` components:
```swift
import Spezi
import HealthKit
import HealthKitDataSource
import Questionnaires
import SwiftUI


class ExampleAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: ExampleStandard()) {
            if HKHealthStore.isHealthDataAvailable() {
                HealthKit {
                    CollectSample(
                        HKQuantityType(.stepCount),
                        deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
                    )
                }
            }
            QuestionnaireDataSource()
        }
    }
}
```

The ``Component`` documentation provides more information about the structure of components.
