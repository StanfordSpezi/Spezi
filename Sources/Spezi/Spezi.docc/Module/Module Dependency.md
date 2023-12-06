# Module Dependency

Define dependence of Modules, establishing an order of initialization.

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

## Overview

``Module``s can define dependencies using the @`Dependency` property wrapper.

This establishes a strict order in which the ``Module/configure()-5pa83`` methods of each ``Module`` are called,
to ensure functionality of a dependency is available at configuration.

> Note: Declaring a cyclic dependency will result in a runtime error. 

```swift
class ExampleModule: Module {
    @Dependency var exampleModuleDependency = ExampleModuleDependency()
}
```

> Note: Refer to the documentation of ``Module/Dependency`` if you need to dynamically compute your list of dependencies in the initializer.

### Default Initialization of Dependencies

By default, `Module`s are initialized with the options passed to the `Module`'s initialization within the ``SpeziAppDelegate/configuration``
section.
If you declare a dependency to a `Module` that is not configured by the users (e.g., some underlying configuration `Module`s might not event be
publicly accessible), is initialized with the instance that was passed to the ``Module/Dependency`` property wrapper.

- Tip: `Module`s can easily provide a default configuration by adopting the ``DefaultInitializable`` protocol.

Below is a short code example.
```swift
class ExampleModuleDependency: Module, DefaultInitializable {
    init() {
        // default options ...
    }
}


class ExampleModule: Module {
    @Dependency var exampleModuleDependency: ExampleModuleDependency
}
```

## Topics

### Declaring Dependencies

- ``Module/Dependency``

### Managing Dependencies

- ``DefaultInitializable``
- ``DependencyManager``

### Building Dependencies

- ``DependencyBuilder``
- ``DependencyCollectionBuilder``
- ``DependencyCollection``
