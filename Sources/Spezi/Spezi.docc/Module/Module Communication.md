# Module Communication

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

## Overview

### Communication

``Module``s can easily communicate with each other using the ``Module/Provide`` and ``Module/Collect`` property wrappers.

Upon configuration, the value of each ``Module/Collect`` property will be collected. Therefore,
all properties must have been property initialized after the initializer of the ``Module`` has been called.
Before the invocation of ``Module/configure()-5pa83``, the data of all ``Module/Provide`` properties will be made available.
Refer to the documentation of the property wrappers for a more detailed overview of the available capabilities.

> Important: Accessing `@Provide` properties within the ``Module/configure()-5pa83`` method or accessing `@Collect` properties before
``Module/configure()-5pa83``, will result in a runtime error. 

Below is a simple example of passing data between ``Module``s.

```swift
class ModuleA: Module {
    @Provide var someGreeting = "Hello"
}

class ModuleB: Module {
    @Provide var someGreeting = ["Hola", "Hallo"]
}


class ModuleC: Module {
    @Collect var allGreetings: [String]

    func collect() {
        print("All the greetings we received: \(allGreetings)") // prints "Hello", "Hola", "Hallo" in any order
    }
}
```

## Topics

### Module Interactions

- ``Module/Provide``
- ``Module/Collect``
