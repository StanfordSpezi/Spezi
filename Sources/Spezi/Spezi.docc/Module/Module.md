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
A `Module` is placed into the ``Configuration`` section of your App to enable and configure it.

The ``Module/configure()-5pa83`` method is called on the initialization of the Spezi instance to perform a lightweight configuration of the module.
It is advised that longer setup tasks are done in an asynchronous task and started during the call of the configure method.

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


#### Enforcing and Applying the Constraint

Use the constraint in your module to access the `Standard` instance that conforms to the protocol.

> Note: You can learn more about creating a ``Standard`` that must meet the requirements of all modules in the ``Standard`` documentation.

```swift
class ExampleModule: Module {
    @StandardActor var standard: any ExampleConstraint

    func configure() {
        // ...
    }
}
```

> Tip: You can access `@StandardActor` once your ``Module/configure()-5pa83`` method is called (e.g., it must not be used in the `init`)
    and can continue to access the Standard actor in methods like ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp``.


## Topics

### Configuration

- ``configure()-5pa83``

### Capabilities
- <doc:Interactions-with-SwiftUI>
- <doc:Interactions-with-Application>
- <doc:Module-Dependency>
- <doc:Module-Communication>
- <doc:Notifications>
