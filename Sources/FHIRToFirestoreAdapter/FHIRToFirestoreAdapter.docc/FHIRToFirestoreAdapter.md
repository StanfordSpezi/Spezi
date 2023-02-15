# ``FHIRToFirestoreAdapter``

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Adapts the output of the `FHIR` standard to be used with the `Firestore` data storage provider.

## Overview

Use the ``FHIRToFirestoreAdapter`` in the adapter result builder of the `Firestore` data storage provider in the CardinalKit `Configuration`.

```swift
class ExampleAppDelegate: CardinalKitAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: FHIR()) {
            Firestore {
                FHIRToFirestoreAdapter()
            }
            // ...
        }
    }
}
```
