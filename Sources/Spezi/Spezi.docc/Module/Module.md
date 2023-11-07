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

## Topics

### Configuration

- ``configure()-5pa83``

### Capabilities
- <doc:Interactions-with-SwiftUI>
- <doc:Module-Dependency>
- <doc:Module-Communication>
