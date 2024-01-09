# ``XCTSpezi``

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

Test functionality for the Spezi framework.

## Overview

This package provides several testing extensions for the Spezi framework.


### Testing Modules

Unit test are particularly useful to test the behavior of a Spezi [`Module`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/module)
without building a complete SwiftUI App and testing functionality via UI Tests.
However, it might be required to resolve and configure dependencies of a `Module` before it is usable.
To do so, you can use ``withDependencyResolution(standard:simulateLifecycle:_:)`` or ``withDependencyResolution(simulateLifecycle:_:)``.
Below is a short code example that demonstrates this functionality.

```swift
import XCTSpezi

let module = ModuleUnderTest()

// resolves all dependencies and configures your module ...
withDependencyResolution {
    module
}

// unit test your module ...
```

## Topics

### Modules

- ``withDependencyResolution(standard:simulateLifecycle:_:)``
- ``withDependencyResolution(simulateLifecycle:_:)``
