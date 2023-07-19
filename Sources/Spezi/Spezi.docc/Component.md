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

The ``Component/ComponentStandard`` defines what Standard the component supports.
The ``Component/configure()-27tt1`` method is called on the initialization of Spezi.

### The Component Standard

A ``Component`` can support any generic standard or add additional constraints using an optional where clause:
```swift
class ExampleComponent<ComponentStandard: Standard>: Component where ComponentStandard: /* ... */ {
    /*... */
}
```

``Component``s can also specify support for only one specific ``Standard`` using a `typealias` definition:
```swift
class ExampleFHIRComponent: Component {
    typealias ComponentStandard = FHIR
}
```


### Dependencies

``Component``s can define dependencies between each other using the @``Component/Dependency`` property wrapper.
The order in which the ``Component/configure()-27tt1`` method of each ``Component`` is called, is automatically
evaluated by the ``DependencyManager``.

> Note: Declaring a cyclic dependency will result in a runtime error. 

```swift
class ExampleComponent<ComponentStandard: Standard>: Component {
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
class ComponentA<ComponentStandard: Standard>: Component {
    @Provide var someGreeting = "Hello World"
}

class ComponentB<ComponentStandard: Standard>: Component {
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

### Dependency

- ``DefaultInitializable``
- ``DependencyManager``
- ``ComponentDependency``
- ``DependencyDescriptor``


