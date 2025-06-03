# Initial Setup

<!--
                  
This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

The Spezi framework can be integrated into any iOS application. You can define which modules you want to integrate into the Spezi configuration.

## 1. Add the Spezi View Modifier

Set up the Spezi framework in your `App` instance of your SwiftUI application using the ``SpeziAppDelegate`` and the `@ApplicationDelegateAdaptor` property wrapper.
Use the `View.spezi(_: SpeziAppDelegate)` view modifier to apply your Spezi configuration to the main view in your SwiftUI `Scene`:
```swift
import HealthKit
import Spezi
import SpeziHealthKit
import SwiftUI


@main
struct ExampleApp: App {
    @ApplicationDelegateAdaptor(SpeziAppDelegate.self) var appDelegate


    var body: some Scene {
        WindowGroup {
            ContentView()
                .spezi(appDelegate)
        }
    }
}
```


## 2. Modify Your Spezi Configuration

A ``Configuration`` defines the ``Standard`` and ``Module``s that are used in a Spezi project.

Ensure that your standard conforms to all protocols enforced by the ``Module``s. If your ``Module``s require protocol conformances
you must add them to your custom type conforming to ``Standard`` and passed to the initializer or extend a prebuilt standard.

Use ``Configuration/init(_:)`` to use default empty standard instance only conforming to ``Standard`` if you do not use any ``Module`` requiring custom protocol conformances.


The following example demonstrates the usage of an `ExampleStandard` standard and the reusable Spezi module `SpeziHealthKit`
```swift
import HealthKit
import Spezi
import SpeziHealthKit
import SwiftUI


class ExampleAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: ExampleStandard()) {
            if HKHealthStore.isHealthDataAvailable() {
                HealthKit {
                    CollectSample(.stepCount, continueInBackground: true)
                }
            }
        }
    }
}
```

Before you configure the ``HealthKit-class`` module, make sure your `Standard` in your Spezi Application conforms to the ``HealthKitConstraint`` protocol to receive HealthKit data.

```swift
import Spezi
import SpeziHealthKit

actor ExampleStandard: Standard, HealthKitConstraint {
    // Add the newly collected HealthKit samples to your application.
    func handleNewSamples<Sample>(
        _ addedSamples: some Collection<Sample>,
        ofType sampleType: SampleType<Sample>
    ) async {
        // ...
    }

    // Remove the deleted HealthKit objects from your application.
    func handleDeletedObjects<Sample>(
        _ deletedObjects: some Collection<HKDeletedObject>,
        ofType sampleType: SampleType<Sample>
    ) async {
        // ...
    }
}
```

The ``Module`` documentation provides more information about the structure of modules.
