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


Open-source framework for rapid development of modern, interoperable digital health applications.

## Overview

> [!NOTE] 
> Refer to the [Initial Setup](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/initial-setup) instructions on how to integrate Spezi into your application!

Spezi introduces a standards-based modular approach to building digital health applications. 


|![Screenshot displaying the UI of the onboarding module.](https://raw.githubusercontent.com/StanfordSpezi/SpeziOnboarding/main/Sources/SpeziOnboarding/SpeziOnboarding.docc/Resources/ConsentView.png#gh-light-mode-only) ![Screenshot displaying the UI of the onboarding module.](https://raw.githubusercontent.com/StanfordSpezi/SpeziOnboarding/main/Sources/SpeziOnboarding/SpeziOnboarding.docc/Resources/ConsentView~dark.png#gh-dark-mode-only)|![Screenshot displaying the UI of the contact module.](https://raw.githubusercontent.com/StanfordSpezi/SpeziContact/main/Sources/SpeziContact/SpeziContact.docc/Resources/Overview.png#gh-light-mode-only) ![Screenshot displaying the UI of the contact module.](https://raw.githubusercontent.com/StanfordSpezi/SpeziContact/main/Sources/SpeziContact/SpeziContact.docc/Resources/Overview~dark.png#gh-dark-mode-only)|![Screenshot displaying the UI of the questionnaire module.](https://raw.githubusercontent.com/StanfordSpezi/SpeziQuestionnaire/main/Sources/SpeziQuestionnaire/SpeziQuestionnaire.docc/Resources/Overview.png#gh-light-mode-only) ![Screenshot displaying the UI of the questionnaire module.](https://raw.githubusercontent.com/StanfordSpezi/SpeziQuestionnaire/main/Sources/SpeziQuestionnaire/SpeziQuestionnaire.docc/Resources/Overview~dark.png#gh-dark-mode-only)
|:--:|:--:|:--:|
|[The Spezi Onboarding Module](https://github.com/StanfordSpezi/SpeziOnboarding)|[The Spezi Contract Module](https://github.com/StanfordSpezi/SpeziContact)|[The Spezi Questionnaire Module](https://github.com/StanfordSpezi/SpeziQuestionnaire)|

The best way to get started and explore the functionality of Spezi is by taking a look at the [Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication). The application incorporates a wide variety of sophisticated modules and demonstrates the usage of these modules in a simple-to-use and easy-to-extend application.


### An Ecosystem of Modules

You can find a list of modules and reusable Swift Packages offered by the Spezi team at Stanford at [the Swift Package Index Stanford Spezi page](https://swiftpackageindex.com/StanfordSpezi).

> [!NOTE] 
> Spezi relies on an ecosystem of modules. Think about what modules you want to build and contribute to the open-source community! Refer to the [Spezi Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/spezi-guide) and [Documentation Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/documentation-guide) about the requirements for Spezi-based software and the ``Module`` documentation to learn more about building your modules.

Learn more about Spezi at [spezi.stanford.edu](https://spezi.stanford.edu).
Reach out to us on social media and use the [Stanford Spezi Discussion Forum](https://github.com/orgs/StanfordSpezi/discussions) to ask any Spezi-related questions or share the projects you built with Spezi.

Check out the [Stanford Biodesign Digital Health GitHub organization](https://github.com/StanfordBDHG) and [Stanford Biodesign Digital Health website at bdh.stanford.edu](https://bdh.stanford.edu), for example, applications built with Spezi and some of our related open-source and research projects.


### The Spezi Building Blocks

> [!NOTE]
> The [Spezi Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/spezi-guide) and [Documentation Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/documentation-guide) guides define the requirements for Spezi-based modules, including terminology, hints, and examples on structuring your Spezi module, Swift Package, and surrounding repository.

A ``Standard`` defines the key coordinator that orchestrates the data flow in the application by meeting requirements defined by modules.
You can learn more about the ``Standard`` protocol and when it is advised to create your own standard in your application in the [`Standard`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/standard) documentation.

A ``Module`` defines a software subsystem providing distinct and reusable functionality.
Modules can use the constraint mechanism to enforce a set of requirements to the standard used in the Spezi-based software where the module is used.
Modules also define dependencies on each other to reuse functionality and can communicate with other modules by offering and collecting information.
They can also conform to different protocols to provide additional access to Spezi features, such as lifecycle management and triggering view updates in SwiftUI using the observable mechanisms in Swift.
You can learn more about modules in the [`Module`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/module) documentation.


For more information, please refer to the [API documentation](https://swiftpackageindex.com/StanfordSpezi/Spezi/documentation).


## Contributing

Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/StanfordSpezi/.github/blob/main/CONTRIBUTING.md) and the [contributor covenant code of conduct](https://github.com/StanfordSpezi/.github/blob/main/CODE_OF_CONDUCT.md) first.


## License

This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordSpezi/Spezi/tree/main/LICENSES) for more information.

![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/Footer.png#gh-light-mode-only)
![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/Footer~dark.png#gh-dark-mode-only)
