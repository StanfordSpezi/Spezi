# Interactions with SwiftUI

Interact with the SwiftUI view hierarchy and its environment.

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

## Overview

A `Module` has several ways of interacting with the SwiftUI view hierarchy and its environment.

### Managing Model state

By using the ``Module/Model`` property wrapper, your `Module` can place an [@Observable](https://developer.apple.com/documentation/observation/observable())
model type into the global SwiftUI view environment.

Below is a short code example that demonstrates this functionality:
```swift
@Observable
class ExampleModel { // your model type you want to make accessible
    var someState: Bool = false

    init() {}
}


class ExampleModel: Module { // your model the app configures
    @Model var model = ExampleModel()
}


class ContentView: Module { // access the model within SwiftUI
    @Environment(ExampleModel.self) var model
}
```

> Note: For more information, refer to the [Managing model data in your app](https://developer.apple.com/documentation/Observation) guide.

### Modifying the global View hierarchy

By using the ``Module/Modifier`` property wrapper, your `Module` can provide a [ViewModifier](https://developer.apple.com/documentation/swiftui/viewmodifier) 
to provide app-wide modifications.

You might find this property useful in scenarios like the following:
* Set global configurations using the [environment(_:_:)](https://developer.apple.com/documentation/swiftui/view/environment(_:_:)) modifier.
* Providing access to a global model state. For more information, have a look at [Share model data throughout a view hierarchy](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app#Share-model-data-throughout-a-view-hierarchy).
* Display UI components using modifiers like [alert(_:isPresented:presenting:actions:message:)](https://developer.apple.com/documentation/swiftui/view/alert(_:ispresented:presenting:actions:message:)-8584l)

> Note: We strongly advise using the new `@Observable` macro instead of the previous `ObservableObject` protocol to achieve optimal performance and
avoid unnecessary view re-rendering.

### Handling an App's Lifecycle

By adopting the ``LifecycleHandler``, your `Module` can provide lifecycle methods to the underlying `UIApplication` and ``Spezi/Spezi`` lifecycle.

### Module Constraints

A ``Standard`` is the key module that orchestrates the data flow within the application and is provided upon App configuration.

Modules can use the constraint mechanism to enforce a set of requirements to the ``Standard`` used in the Spezi-based software where the module is used.
This mechanism follows a two-step process:

#### Standard Constraint

Define a standard constraint required by your module.
The constraint protocol **must** conform to the `Standard` protocol.
```swift
protocol ExampleConstraint: Standard {
    // ...
}
```


#### 2. Enforcing and Applying the Constraint

Use the constraint in your module to access the `Standard` instance that conforms to the protocol.
```swift
class ExampleModule: Module {
    @StandardActor var standard: any ExampleConstraint

    // ...
}
```

> Note: You can learn more about creating a ``Standard`` that must meet the requirements of all modules in the ``Standard`` documentation.


## Topics

### Managing Model State

- ``Module/Model``
- ``EnvironmentAccessible``

### Interactions

- ``Module/StandardActor``
- ``Module/Modifier``
- ``LifecycleHandler``
