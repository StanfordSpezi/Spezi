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


Open-source framework for the rapid development of modern, interoperable digital health applications.

## Overview

> [!NOTE] 
> Refer to the [Initial Setup](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/initial-setup) instructions to integrate Spezi into your application.

Spezi introduces a module-based approach to building digital health applications. 

<table style="width: 80%">
  <tr>
    <td align="center" width="33.33333%">
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziOnboarding/main/Sources/SpeziOnboarding/SpeziOnboarding.docc/Resources/OnboardingView.png#gh-light-mode-only" alt="Screenshot displaying the UI of the onboarding module" width="80%"/>
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziOnboarding/main/Sources/SpeziOnboarding/SpeziOnboarding.docc/Resources/OnboardingView~dark.png#gh-dark-mode-only" alt="Screenshot displaying the UI of the onboarding module" width="80%"/>
    </td>
    <td align="center" width="33.33333%">
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziDevices/main/Sources/SpeziDevicesUI/SpeziDevicesUI.docc/Resources/PairedDevices.png#gh-light-mode-only" alt="Screenshot displaying Spezi Devices and Bluetooth pairing user interface" width="80%"/>
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziDevices/main/Sources/SpeziDevicesUI/SpeziDevicesUI.docc/Resources/PairedDevices~dark.png#gh-dark-mode-only" alt="Screenshot displaying Spezi Devices and Bluetooth pairing user interface" width="80%"/>
    </td>
    <td align="center" width="33.33333%">
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziQuestionnaire/main/Sources/SpeziQuestionnaire/SpeziQuestionnaire.docc/Resources/Overview.png#gh-light-mode-only" alt="Screenshot displaying the UI of the questionnaire module" width="80%"/>
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziQuestionnaire/main/Sources/SpeziQuestionnaire/SpeziQuestionnaire.docc/Resources/Overview~dark.png#gh-dark-mode-only" alt="Screenshot displaying the UI of the questionnaire module" width="80%"/>
    </td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://github.com/StanfordSpezi/SpeziOnboarding">
        <code>Spezi Onboarding</code>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/StanfordSpezi/SpeziBluetooth">
        <code>Spezi Bluetooth</code>
      </a> and
      <a href="https://github.com/StanfordSpezi/SpeziDevices">
        <code>Spezi Devices</code>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/StanfordSpezi/SpeziQuestionnaire">
        <code>Spezi Questionnaire</code>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziAccount/main/Sources/SpeziAccount/SpeziAccount.docc/Resources/AccountSetup.png#gh-light-mode-only" alt="Screenshot displaying the account setup view with email and password prompt and Sign In with Apple button" width="80%"/>
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziAccount/main/Sources/SpeziAccount/SpeziAccount.docc/Resources/AccountSetup~dark.png#gh-dark-mode-only" alt="Screenshot displaying the account setup view with email and password prompt and Sign In with Apple button" width="80%"/>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziViews/main/Sources/SpeziValidation/SpeziValidation.docc/Resources/Validation.png#gh-light-mode-only" alt="Three different text fields showing validation errors with Spezi Validation" width="80%"/>
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziViews/main/Sources/SpeziValidation/SpeziValidation.docc/Resources/Validation~dark.png#gh-dark-mode-only" alt="Three different text fields showing validation errors with Spezi Validation" width="80%"/>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziLLM/main/Sources/SpeziLLMLocal/SpeziLLMLocal.docc/Resources/ChatView.png#gh-light-mode-only" alt="Chat view of a locally executed LLM using the Spezi LLM module" width="80%"/>
      <img src="https://raw.githubusercontent.com/StanfordSpezi/SpeziLLM/main/Sources/SpeziLLMLocal/SpeziLLMLocal.docc/Resources/ChatView~dark.png#gh-dark-mode-only" alt="Chat view of a locally executed LLM using the Spezi LLM module" width="80%"/>
    </td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://github.com/StanfordSpezi/SpeziAccount">
        <code>Spezi Account</code>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/StanfordSpezi/SpeziViews">
        <code>Spezi Views</code>
      </a>, including
      <a href="https://swiftpackageindex.com/StanfordSpezi/SpeziViews/documentation/spezivalidation">
        <code>SpeziValidation</code>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/StanfordSpezi/SpeziLLM">
        <code>Spezi LLM</code>
      </a>
    </td>
  </tr>
</table>

The best way to get started and explore Spezi’s functionality is by using the [Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication).
The application incorporates a wide range of modules and demonstrates their usage in a simple-to-use and easy-to-extend application.


### An Ecosystem of Modules

You can find a list of modules and reusable Swift packages offered by the Spezi team at Stanford on the [Swift Package Index Stanford Spezi page](https://swiftpackageindex.com/StanfordSpezi).

> [!NOTE] 
> Spezi relies on an ecosystem of modules. Consider what modules you want to build and contribute to the open-source community. Refer to the [Spezi Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/spezi-guide) and [Documentation Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/documentation-guide) for requirements for Spezi-based software, and see the ``Module`` documentation to learn more about building your modules.

Learn more about Spezi at [spezi.stanford.edu](https://spezi.stanford.edu).
Connect with us on social media, and use the [Stanford Spezi Discussion Forum](https://github.com/orgs/StanfordSpezi/discussions) to ask questions or share projects you have built with Spezi.

Check out the [Stanford Biodesign Digital Health GitHub organization](https://github.com/StanfordBDHG) and the [Stanford Biodesign Digital Health website](https://bdh.stanford.edu) for applications built with Spezi and related open-source and research projects.

> [!NOTE]  
> You can find a complete list of the Swift-based Spezi modules on the [Spezi Swift Package Index](https://swiftpackageindex.com/StanfordSpezi) page.


### The Spezi Building Blocks

> [!NOTE]
> The [Spezi Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/spezi-guide) and [Documentation Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/documentation-guide) outline the requirements for Spezi-based modules, including terminology, guidance, and examples on structuring a Spezi module, Swift package, and repository.

A ``Standard`` defines the key coordinator that orchestrates data flow in an application by meeting requirements defined by modules.
You can learn more about the ``Standard`` protocol and when it is advised to create your own standard in the [`Standard`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/standard) documentation.

A ``Module`` defines a software subsystem that provides distinct and reusable functionality.
Modules can use the constraint mechanism to enforce a set of requirements for the standard used in Spezi-based software.
They can also define dependencies on each other to reuse functionality and can communicate with other modules by offering and collecting information.
Modules may conform to different protocols to access additional Spezi features, such as lifecycle management and triggering view updates in SwiftUI using Swift’s observable mechanisms.
You can learn more about modules in the [`Module`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/module) documentation.


For more information, see the [API documentation](https://swiftpackageindex.com/StanfordSpezi/Spezi/documentation).


## Contributing

Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/StanfordSpezi/.github/blob/main/CONTRIBUTING.md) and the [contributor covenant code of conduct](https://github.com/StanfordSpezi/.github/blob/main/CODE_OF_CONDUCT.md) first.


## License

This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordSpezi/Spezi/tree/main/LICENSES) for more information.

![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/Footer.png#gh-light-mode-only)
![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/Footer~dark.png#gh-dark-mode-only)
