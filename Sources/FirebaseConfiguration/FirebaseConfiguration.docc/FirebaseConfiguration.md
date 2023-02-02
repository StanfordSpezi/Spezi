# ``FirebaseConfiguration``

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Shared component to serve as a single point to configure the Firebase set of dependencies.

## Overview

The `configure()` method calls `FirebaseApp.configure()`.

Use the `@Dependency` property wrapper to define a dependency on this component and ensure that `FirebaseApp.configure()` is called before any
other Firebase-related components:

```swift
public final class YourFirebaseComponent<ComponentStandard: Standard>: Component {
    @Dependency private var configureFirebaseApp: ConfigureFirebaseApp

    // ...
}
```
