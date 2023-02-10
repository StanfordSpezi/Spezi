# Setup

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

The CardinalKit framework can be integrated into any iOS application. You can define which modules you want to integrate into the CardinalKit configuration.

## 1. Add the CardinalKit View Modifier

Set up the CardinalKit framework in your `App` instance of your SwiftUI application using the ``CardinalKitAppDelegate`` and the `@UIApplicationDelegateAdaptor` property wrapper.
Use the `View.cardinalKit(_: CardinalKitAppDelegate)` view modifier to apply your CardinalKit configuration to the main view in your SwiftUI `Scene`:
```swift
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
```


## 2. Modify Your CardinalKit Configuration

A ``Configuration`` defines the ``Standard`` and ``Component``s that are used in a CardinalKit project.

Register your different ``Component``s (or more sophisticated ``Module``s) using the ``CardinalKitAppDelegate/configuration`` property, e.g., using the
`FHIR` standard integrated into the CardinalKit Swift Package.

The ``Configuration`` initializer requires a ``Standard`` that is used in the CardinalKit project.
The standard defines a shared repository to facilitate communication between different modules.

The ``Configuration/init(standard:_:)``'s components result builder allows the definition of different components, including conditional statements or loops.

The following example demonstrates the usage of the `FHIR` standard and different built-in CardinalKit modules, including the `HealthKit` and `QuestionnaireDataSource` components:
```swift
import CardinalKit
import FHIR
import HealthKit
import HealthKitDataSource
import HealthKitToFHIRAdapter
import Questionnaires
import SwiftUI


class ExampleAppDelegate: CardinalKitAppDelegate {
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

### Core CardinalKit Types

- ``CardinalKit/CardinalKit``
- ``CardinalKitAppDelegate``
- ``Standard``
