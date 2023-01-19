# ``LocalStorage``

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Store data on-disk.

## Overview

The ``LocalStorage`` module enables the on-disk storage of data in mobile applications. The ``LocalStorageSetting`` enables configuring how data in the ``LocalStorage`` module can be stored and retrieved.

The data stored can optionally be encrypted by importing the `SecureStorage` module.


## Add the LocalStorage Module

You can configure the ``LocalStorage/LocalStorage`` module in the `CardinalKitAppDelegate`.

```swift
import CardinalKit
import LocalStorage


class ExampleDelegate: CardinalKitAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: ExampleStandard()) {
            LocalStorage()
        }
    }
}
```

You can then use the ``LocalStorage/LocalStorage`` class in any SwiftUI view.

```swift
struct ExampleLocalStorageView: View {
    @EnvironmentObject var localStorage: LocalStorage<ExampleStandard>
    
    
    var body: some View {
        // ...
    }
}
```

Alternatively it is common to use the ``LocalStorage/LocalStorage`` component in other components as a dependency.

## Use the LocalStorage Module

### Storing data

Use the ``LocalStorage/LocalStorage`` component to store data that conforms to `Encodable`.

```swift
struct Note: Codable, Equatable {
    let text: String
    let date: Date
}

let note = Note(text: "CardinalKit is awesome!", date: Date())

do {
    try await localStorage.store(
        note,
        storageKey: "MyNote",
        settings: .unencrypted()
    )
} catch {
    // Handle storage error here
    // ...
}

```

### Reading stored data

Use the ``LocalStorage/LocalStorage`` component to read previously stored data.

```swift
do {
    let storedNote: Note = try await localStorage.read(
        storageKey: "MyNote", 
        settings: .unencrypted()
    )
    // Do something with `storedNote`.
} catch {
    // Handle read error.
    // ...
}
```

### Deleting stored data

Use the ``LocalStorage/LocalStorage`` component to delete previously stored data.

```swift
do {
    try await localStorage.delete(storageKey: "MyNote")
} catch {
    // Handle delete error.
    // ...
}
```
