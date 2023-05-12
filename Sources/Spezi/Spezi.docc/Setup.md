# Setup

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

Register your different ``Component``s (or more sophisticated ``Module``s) using the ``SpeziAppDelegate/configuration`` property, e.g., using the
`FHIR` standard integrated into the Spezi Swift Package.

The ``Configuration`` initializer requires a ``Standard`` that is used in the Spezi project.
The standard defines a shared repository to facilitate communication between different modules.

The ``Configuration/init(standard:_:)``'s components result builder allows the definition of different components, including conditional statements or loops.

The following example demonstrates the usage of the `FHIR` standard and different built-in Spezi modules, including the `HealthKit` and `QuestionnaireDataSource` components:
```swift
import Spezi
import FHIR
import HealthKit
import HealthKitDataSource
import HealthKitToFHIRAdapter
import Questionnaires
import SwiftUI


class ExampleAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: FHIR()) {
            if HKHealthStore.isHealthDataAvailable() {
                HealthKit {
                    CollectSample(
                        HKQuantityType(.stepCount),
                        deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
                    )
                } adapter: {
                    HealthKitToFHIRAdapter()
                }
            }
            QuestionnaireDataSource()
        }
    }
}
```

The ``Component`` documentation provides more information about the structure of components.

## Topics

### Core Spezi Types

- ``Spezi/Spezi``
- ``SpeziAppDelegate``
- ``Standard``
