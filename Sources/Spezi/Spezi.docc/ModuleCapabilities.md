# Module Capabilities

<!--
                  
This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Building a module provides an easy one-stop solution to support different Spezi components and provide this functionality to the Spezi ecosystem.

## Components

A ``Component`` defines a software subsystem that can be configured as part of the ``SpeziAppDelegate/configuration``.

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

> Note: You can learn more about a ``Standard`` in the ``Standard`` documentation.

### Dependencies

A ``Component`` can define the dependencies using the @``Component/Dependency`` property wrapper:
```swift
class ExampleComponent<ComponentStandard: Standard>: Component {
    @Dependency var exampleComponentDependency = ExampleComponentDependency()
}
```

Some components do not need a default value assigned to the property if they provide a default configuration and conform to ``DefaultInitializable``.
```swift
class ExampleComponent<ComponentStandard: Standard>: Component {
    @Dependency var exampleComponentDependency: ExampleComponentDependency
}
```

You can access the wrapped value of the ``Component/Dependency`` after the ``Component`` is configured using ``Component/configure()-27tt1``,
e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp`` function.

> Note: You can learn more about a ``Component/Dependency`` in the ``Component/Dependency`` documentation. You can also dynamically define dependencies using the ``Component/DynamicDependencies`` property wrapper.


## Component Capabilities

Components can also conform to different additional protocols to provide additional access to Spezi features.
- ``LifecycleHandler``: Delegate methods are related to the  `UIApplication` and ``Spezi/Spezi`` lifecycle.
- ``ObservableObjectProvider``: A ``Component`` can conform to ``ObservableObjectProvider`` to inject `ObservableObject`s in the SwiftUI view hierarchy.

### LifecycleHandler

The ``LifecycleHandler`` delegate methods are related to the  `UIApplication` and ``Spezi/Spezi`` lifecycle.

Conform to the `LifecycleHandler` protocol to get updates about the application lifecycle similar to the `UIApplicationDelegate` on an app basis.

You can, e.g., implement the following functions to get informed about the application launching and being terminated:
- ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp``
- ``LifecycleHandler/applicationWillTerminate(_:)-35fxv``

### ObservableObjectProvider

A ``Component`` can conform to ``ObservableObjectProvider`` to inject `ObservableObject`s in the SwiftUI view hierarchy using ``ObservableObjectProvider/observableObjects-3hktb``


Reference types conforming to `ObservableObject` can be used in SwiftUI views to inform a view about changes in the object.
You can create and use them in a view using `@ObservedObject` or get it from the SwiftUI environment using `@EnvironmentObject`.

A Component can conform to `ObservableObjectProvider` to inject `ObservableObject`s in the SwiftUI view hierarchy.
You define all `ObservableObject`s that should be injected using the ``ObservableObjectProvider/observableObjects-3hktb`` property.
```swift
class MyComponent<ComponentStandard: Standard>: ObservableObjectProvider {
    public var observableObjects: [any ObservableObject] {
        [/* ... */]
    }
}
```

`ObservableObjectProvider` provides a default implementation of the ``ObservableObjectProvider/observableObjects-3hktb`` If your type conforms to `ObservableObject`
that just injects itself into the SwiftUI view hierarchy:
```swift
class MyComponent<ComponentStandard: Standard>: ObservableObject, ObservableObjectProvider {
    @Published
    var test: String

    // ...
}
```


## Modules

All these component capabilities are combined in the ``Module`` protocol, making it an easy one-stop solution to support all these different functionalities and build a capable Spezi module.

A ``Module`` is a ``Component`` that also includes
- Conformance to a ``LifecycleHandler``
- Automatic injection in the SwiftUI view hierarchy (``ObservableObjectProvider`` & `ObservableObject`)


## Topics

### Modules & Component Capabilities

- ``Component``
- ``Module``
- ``LifecycleHandler``
- ``ObservableObjectProvider``
