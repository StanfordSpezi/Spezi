# Module Communication

Establish data flow between `Module`s without establishing a dependency hierarchy.  

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

## Overview

``Module``s can easily communicate with each other using the ``Module/Provide`` and ``Module/Collect`` property wrappers.

Upon configuration, the value of each ``Module/Collect`` property will be collected. Therefore,
all properties must have been property initialized after the initializer of the ``Module`` has been called.
Before the invocation of ``Module/configure()-5pa83``, the data of all ``Module/Provide`` properties will be made available.
Refer to the documentation of the property wrappers for a more detailed overview of the available capabilities.

> Important: Values must be written to `@Provide` within the initializer and cannot be changed afterwards. `@Collect` properties
    may only be accessed once the ``Module/configure()-5pa83`` method is getting called. Failure to comply will result in a runtime crash. 

Below is a simple example of passing data between ``Module``s.

```swift
class ModuleA: Module {
    @Provide var someGreeting = "Hello"
}

class ModuleB: Module {
    @Provide var someGreeting: [String]

    init() {
        someGreeting = = ["Hola", "Hallo"]
    }
}


class ModuleC: Module {
    @Collect var allGreetings: [String]

    func configure() {
        print("All the greetings we received: \(allGreetings)") // prints "Hello", "Hola", "Hallo" in any order
    }
}
```

## Topics

### Module Interactions

- ``Module/Provide``
- ``Module/Collect``
