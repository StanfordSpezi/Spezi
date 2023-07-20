<!--

This source file is part of the Stanford Spezi open-source project.

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
  
-->

# Spezi

[![Build and Test](https://github.com/StanfordSpezi/Spezi/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/StanfordSpezi/Spezi/actions/workflows/build-and-test.yml)
[![codecov](https://codecov.io/gh/StanfordSpezi/Spezi/branch/main/graph/badge.svg?token=KHU2K1HTAM)](https://codecov.io/gh/StanfordSpezi/Spezi)
[![DOI](https://zenodo.org/badge/549199889.svg)](https://zenodo.org/badge/latestdoi/549199889)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStanfordSpezi%2FSpezi%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/StanfordSpezi/Spezi)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStanfordSpezi%2FSpezi%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/StanfordSpezi/Spezi)

An open-source framework for the rapid development of modern, interoperable digital health applications.

For more information, please refer to the [API documentation](https://swiftpackageindex.com/StanfordSpezi/Spezi/documentation).

## The Spezi Architecture

Spezi introduces a standards-based modular approach to building digital health applications. 
A 'Standard' defines the key component that orchestrates the data flow in the application by meeting requirements defined by components.
You can learn more about the 'Standard' protocol and when it is advised to create your own standard in your application in the <doc:Standard> documentation.

A 'Component' defines a software subsystem providing distinct and reusable functionality.
Components can use the constraint mechanism to enforce a set of requirements to the standard used in the Spezi-based software where the component is used.
Components also define dependencies on each other to reuse functionality and can communicate with other components by offering and collecting information.
They can also conform to different additional protocols to provide additional access to Spezi features, such lifecycle management and triggering view updates in SwiftUI using the observable mechanisms in Swift.
You can learn more about components in the <doc:Component> documentation.

To simplify the creation of components, a common set of functionalities typically used by components is summarized in the 'Module' protocol, making it an easy one-stop solution to support all these different functionalities and build a capable Spezi module.

> Note: Spezi relies on an ecosystem of modules. Think about what modules you want to build and contribute to the open-source community! Refer to 'Component' and 'Module' documentation to learn more about building your modules.

You can find a list of modules and reusable Swift Packages offered by the Spezi team at Stanford at https://swiftpackageindex.com/StanfordSpezi.
Learn more about Spezi at https://spezi.stanford.edu.
Reach out to us on social media and use the [Stanford Spezi Discussion Forum](https://github.com/orgs/StanfordSpezi/discussions) to ask any Spezi-related questions or share the projects you built with Spezi.

Check out the [Stanford Biodesign Digital Health Group GitHub organization](), for example, applications built with Spezi and some of our related open-source and research projects.

The [API documentation](https://swiftpackageindex.com/StanfordSpezi/Spezi/documentation) includes a selector to switch between the different Swift Package Manager Targets, allowing you to explore the different modules that are included in the Spezi repository.

## The Spezi Template Application

The [Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication) provides a great starting point and example about using the different Spezi modules.

## Contributing

Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/StanfordSpezi/.github/blob/main/CONTRIBUTING.md) and the [contributor covenant code of conduct](https://github.com/StanfordSpezi/.github/blob/main/CODE_OF_CONDUCT.md) first.


## License

This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordSpezi/Spezi/tree/main/LICENSES) for more information.

![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/FooterLight.png#gh-light-mode-only)
![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/FooterDark.png#gh-dark-mode-only)
