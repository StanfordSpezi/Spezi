# Module Capabilities

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Building a module provides an easy one-stop solution to support different CardinalKit components and provide this functionality to the CardinalKit ecosystem.

## Components

A ``Component`` defines a software subsystem that can be configured as part of the ``CardinalKitAppDelegate/configuration``.

The ``Component/ComponentStandard`` defines what Standard the component supports.
The ``Component/configure()-m7ic`` method is called on the initialization of CardinalKit.

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

> Note: You can learn more about a ``Standard`` in the ``Standard`` docmentation.

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

You can access the wrapped value of the ``Component/Dependency`` after the ``Component`` is configured using ``Component/configure()-5lup3``,
e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-26h4k`` function.

> Note: You can learn more about a ``Component/Dependency`` in the ``Component/Dependency`` docmentation. You can also dynamically define dependencies using the ``Component/DynamicDependencies`` property wrapper.


## Component Capabilities

Components can also conform to different additional protocols to provide additional access to CardinalKit features.
- ``LifecycleHandler``: Delegate methods are related to the  `UIApplication` and ``CardinalKit/CardinalKit`` lifecycle.
- ``ObservableObjectProvider``: A ``Component`` can conform to ``ObservableObjectProvider`` to inject `ObservableObject`s in the SwiftUI view hierarchy.

### LifecycleHandler

The ``LifecycleHandler`` delegate methods are related to the  `UIApplication` and ``CardinalKit/CardinalKit`` lifecycle.

Conform to the `LifecycleHandler` protocol to get updates about the application lifecycle similar to the `UIApplicationDelegate` on an app basis.

You can, e.g., implement the following functions to get informed about the application launching and being terminated:
- ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-26h4k``
- ``LifecycleHandler/applicationWillTerminate(_:)-8wh06``

### ObservableObjectProvider

A ``Component`` can conform to ``ObservableObjectProvider`` to inject `ObservableObject`s in the SwiftUI view hierarchy using ``ObservableObjectProvider/observableObjects-6w1nz``


Reference types conforming to `ObservableObject` can be used in SwiftUI views to inform a view about changes in the object.
You can create and use them in a view using `@ObservedObject` or get it from the SwiftUI environment using `@EnvironmentObject`.

A Component can conform to `ObservableObjectProvider` to inject `ObservableObject`s in the SwiftUI view hierarchy.
You define all `ObservableObject`s that should be injected using the ``ObservableObjectProvider/observableObjects-5nl18`` property.
```swift
class MyComponent<ComponentStandard: Standard>: ObservableObjectProvider {
    public var observableObjects: [any ObservableObject] {
        [/* ... */]
    }
}
```

`ObservableObjectProvider` provides a default implementation of the ``ObservableObjectProvider/observableObjects-5nl18`` If your type conforms to `ObservableObject`
that just injects itself into the SwiftUI view hierarchy:
```swift
class MyComponent<ComponentStandard: Standard>: ObservableObject, ObservableObjectProvider {
    @Published
    var test: String

    // ...
}
```


## Modules

All these component capabilities are combined in the ``Module`` protocol, making it an easy one-stop solution to support all these different functionalities and build a capable CardinalKit module.

A ``Module`` is a ``Component`` that also includes
- Conformance to a ``LifecycleHandler``
- Persistance in the ``CardinalKit`` instance's ``CardinalKit/CardinalKit/typedCollection`` (using a conformance to ``TypedCollectionKey``)
- Automatic injection in the SwiftUI view hierachy (``ObservableObjectProvider`` & `ObservableObject`)


## Topics

### Modules & Component Capabilities

- ``Component``
- ``Module``
- ``LifecycleHandler``
- ``ObservableObjectProvider``
