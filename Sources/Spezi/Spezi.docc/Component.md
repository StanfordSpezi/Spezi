# ``Spezi/Component``

<!--
                  
This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Overview

A ``Component``'s initializer can be used to configure its behavior as a subsystem in Spezi-based software.

The ``Component/configure()-27tt1`` method is called on the initialization of the Spezi instance to perform a lightweight configuration of the component.
Both ``Component/Dependency`` and ``Component/DynamicDependencies`` are available and configured at this point.
It is advised that longer setup tasks are done in an asynchronous task and started during the call of the configure method.

### Component Constraints

Components can use the constraint mechanism to enforce a set of requirements to the ``Standard`` used in the Spezi-based software where the component is used.
This mechanism follows a two-step process:

#### 1. Standard Constraint

Define a standard constraint that is required by your component.
The constraint protocol **must** conform to the `Standard` protocol.
```swift
protocol ExampleConstraint: Standard {
    // ...
}
```


#### 2. Enforcing and Utilizing the Constraint with the `@StandardActor` Property Wrapper

Use the constraint in your component to access the `Standard` instance that conforms to the protocol.
```swift
class ExampleComponent: Component {
    @StandardActor var standard: any ExampleConstraint
   
    // ...
}
```

> Note: You can learn more about creating a ``Standard`` that must meet the requirements of all components in the ``Standard`` documentation.

### Dependencies

``Component``s can define dependencies between each other using the @``Component/Dependency`` property wrapper.
The order in which the ``Component/configure()-27tt1`` method of each ``Component`` is called, is automatically
evaluated by the ``DependencyManager``.

> Note: Declaring a cyclic dependency will result in a runtime error. 

```swift
class ExampleComponent: Component {
    @Dependency var exampleComponentDependency = ExampleComponentDependency()
}
```

### Communication

``Component``s can easily communicate with each other using the ``Component/Provide`` and ``Component/Collect`` property wrappers.

On configuration, the value of each ``Component/Collect`` property will be collected and stored in the ``SpeziStorage``. Therefore,
all properties must have been property initialized after the initializer of the ``Component`` has been called.
Before the invocation of ``Component/configure()-27tt1``, the data of all ``Component/Provide`` properties will be made available.
Refer to the documentation of the property wrappers for a more detailed overview of the available capabilities.

> Important: Accessing `@Provide` properties within the ``Component/configure()-27tt1`` method or accessing `@Collect` properties before
    ``Component/configure()-27tt1`` was called will result in a runtime error. 

Below is a simple example of passing data between ``Component``s.

```swift
class ComponentA: Component {
    @Provide var someGreeting = "Hello World"
}

class ComponentB: Component {
    @Collect var allGreetings: [String]

    func collect() {
        print("All the greetings we received: \(allGreetings)")
    }
}
```

### Additional Capabilities

Components can also conform to different additional protocols to provide additional access to Spezi features.
- ``LifecycleHandler``: Delegate methods are related to the  `UIApplication` and ``Spezi/Spezi`` lifecycle.
- ``ObservableObjectProvider``: A ``Component`` can conform to ``ObservableObjectProvider`` to inject `ObservableObject`s in the SwiftUI view hierarchy.

All these protocols are combined in the ``Module`` protocol, making it an easy one-stop solution to support all these different functionalities and build a capable Spezi module.


## Topics

### Properties

- ``Component/Dependency``
- ``Component/DynamicDependencies``
- ``Component/Provide``
- ``Component/Collect``
- ``Component/StandardActor``

### Capabilities

- ``Module``
- ``LifecycleHandler``
- ``ObservableObjectProvider``

### Dependency

- ``DefaultInitializable``
- ``DependencyManager``
- ``ComponentDependency``
- ``DependencyDescriptor``


