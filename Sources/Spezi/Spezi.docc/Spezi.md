# ``Spezi``

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

Open-source framework for rapid development of modern, interoperable digital health applications.

## Overview

> Note: Refer to the <doc:Setup> instructions on how to integrate Spezi into your application!

Spezi introduces a standards-based modular approach to building digital health applications. 
A ``Standard`` defines the key component that orchestrates the data flow in the application by meeting requirements defined by components.
You can learn more about the ``Standard`` protocol and when it is advised to create your own standard in your application in the <doc:Standard> documentation.

A ``Component`` defines a software subsystem providing distinct and reusable functionality.
Components can use the constraint mechanism to enforce a set of requirements to the standard used in the Spezi-based software where the component is used.
Components also define dependencies on each other to reuse functionality and can communicate with other components by offering and collecting information.
They can also conform to different additional protocols to provide additional access to Spezi features, such lifecycle management and triggering view updates in SwiftUI using the observable mechanisms in Swift.
You can learn more about components in the <doc:Component> documentation.

To simplify the creation of components, a common set of functionalities typically used by components is summarized in the ``Module`` protocol, making it an easy one-stop solution to support all these different functionalities and build a capable Spezi module.

> Note: Spezi relies on an ecosystem of modules. Think about what modules you want to build and contribute to the open-source community! Refer to ``Component`` and ``Module`` documentation to learn more about building your modules.

You can find a list of modules and reusable Swift Packages offered by the Spezi team at Stanford at https://swiftpackageindex.com/StanfordSpezi.
Learn more about Spezi at https://spezi.stanford.edu.
Reach out to us on social media and use the [Stanford Spezi Discussion Forum](https://github.com/orgs/StanfordSpezi/discussions) to ask any Spezi-related questions or share the projects you built with Spezi.

Check out the [Stanford Biodesign Digital Health Group GitHub organization](), for example, applications built with Spezi and some of our related open-source and research projects.

## Topics

### Spezi Setup

- <doc:Setup>
- ``Spezi/Spezi``
- ``SpeziAppDelegate``
- ``Standard``

### Component

- ``Component``

### Modules

- ``Module``

### Configuration

- ``Configuration``
- ``ComponentBuilder``
- ``ComponentCollection``

### Shared Repository

- <doc:Shared-Repository>
- ``SharedRepository``
- ``RepositoryAnchor``
- ``KnowledgeSource``
- ``SpeziAnchor``
- ``SpeziStorage``

### Utilities

- ``AnyArray``
- ``AnyOptional``
