# ``Spezi/Module``

<!--
                  
This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Overview

A ``Module``'s initializer can be used to configure its behavior as a subsystem in Spezi-based software.

The ``Module/configure()-5pa83`` method is called on the initialization of the Spezi instance to perform a lightweight configuration of the module.
Both ``Module/Dependency`` and ``Module/DynamicDependencies`` are available and configured at this point.
It is advised that longer setup tasks are done in an asynchronous task and started during the call of the configure method.

### Module Constraints

Modules can use the constraint mechanism to enforce a set of requirements to the ``Standard`` used in the Spezi-based software where the module is used.
This mechanism follows a two-step process:

#### 1. Standard Constraint

Define a standard constraint required by your module.
The constraint protocol **must** conform to the `Standard` protocol.
```swift
protocol ExampleConstraint: Standard {
    // ...
}
```


#### 2. Enforcing and Utilizing the Constraint with the `@StandardActor` Property Wrapper

Use the constraint in your module to access the `Standard` instance that conforms to the protocol.
```swift
class ExampleModule: Module {
    @StandardActor var standard: any ExampleConstraint
   
    // ...
}
```

> Note: You can learn more about creating a ``Standard`` that must meet the requirements of all modules in the ``Standard`` documentation.

### Communication

``Module``s can easily communicate with each other using the ``Module/Provide`` and ``Module/Collect`` property wrappers.

On configuration, the value of each ``Module/Collect`` property will be collected and stored in the ``SpeziStorage``. Therefore,
all properties must have been property initialized after the initializer of the ``Module`` has been called.
Before the invocation of ``Module/configure()-5pa83``, the data of all ``Module/Provide`` properties will be made available.
Refer to the documentation of the property wrappers for a more detailed overview of the available capabilities.

> Important: Accessing `@Provide` properties within the ``Module/configure()-5pa83`` method or accessing `@Collect` properties before
    ``Module/configure()-5pa83`` was called will result in a runtime error. 

Below is a simple example of passing data between ``Module``s.

```swift
class ModuleA: Module {
    @Provide var someGreeting = "Hello World"
}

class ModuleB: Module {
    @Collect var allGreetings: [String]

    func collect() {
        print("All the greetings we received: \(allGreetings)")
    }
}
```

### Managing Model state

By using the ``Module/Model`` property wrapper, your `Module` can an place observable model type into the global SwiftUI view environment.

Below is a shirt code example that demonstrates this functionality:
```swift
@Observable
class ExampleModel {
    var someState: Bool = false

    init() {}
}

class ExampleModel: Module {
    @Model var model = ExampleModel()
}
```

> Note: For more information, refer to the [Managing model data in your app](https://developer.apple.com/documentation/Observation) guide.

### Modifying the global View hierarchy

By using the ``Module/Modifier`` property wrapper, your `Module` can provide a [ViewModifier](https://developer.apple.com/documentation/swiftui/viewmodifier) 
to provide app-wide modifications.

You might find this property useful in scenarios like the following:
* Set global configurations using the [environment(_:_:)](https://developer.apple.com/documentation/swiftui/view/environment(_:_:)) modifier.
* Providing access to a global model state. For more information have a look at [Share model data throughout a view hierarchy](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app#Share-model-data-throughout-a-view-hierarchy).
* Display UI components using modifiers like [alert(_:isPresented:presenting:actions:message:)](https://developer.apple.com/documentation/swiftui/view/alert(_:ispresented:presenting:actions:message:)-8584l)

> Note: We strongly advise using the new `@Observable` macro instead of the previous `ObservableObject` protocol to achieve optimal performance and
    avoid unnecessary view re-rendering.

### Handling an App's Lifecycle

My adopting the ``LifecycleHandler`` your `Module` can provide lifecycle methods to the underlying `UIApplication` and ``Spezi/Spezi`` lifecycle.


### Dependencies

``Module``s can define dependencies between each other using the @``Module/Dependency`` property wrapper.
The order in which the ``Module/configure()-5pa83`` method of each ``Module`` is called, is automatically
evaluated by the ``DependencyManager``.

> Note: Declaring a cyclic dependency will result in a runtime error. 

```swift
class ExampleModule: Module {
    @Dependency var exampleModuleDependency = ExampleModuleDependency()
}
```

## Topics

### Standard

- ``Module/StandardActor``

### Communication

- ``Module/Provide``
- ``Module/Collect``

### Interaction with SwiftUI

- ``Module/Model``
- ``Module/Modifier``
- ``EnvironmentAccessible``

### Lifecycle Handling

- ``LifecycleHandler``

### Dependency

- ``Module/Dependency``
- ``Module/DynamicDependencies``
- ``DefaultInitializable``
- ``DependencyManager``
- ``ModuleDependency``
- ``DependencyDescriptor``
