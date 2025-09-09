# ``Spezi``

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

Open-source framework for the rapid development of modern, interoperable digital health applications.

## Overview

> Tip: Refer to the <doc:Initial-Setup> instructions to integrate Spezi into your application.

Spezi introduces a module-based approach to building digital health applications. 

<!--
Unfortunately, DocC currently does not support dark mode images: https://github.com/apple/swift-docc/pull/359#issuecomment-1214405608
-->
@Row {
    @Column {
        @Image(source: "https://raw.githubusercontent.com/StanfordSpezi/SpeziConsent/main/Sources/SpeziConsent/SpeziConsent.docc/Resources/Consent1.png", alt: "Screenshot displaying the UI of the consent module.") {
            The [Spezi Onboarding](https://github.com/StanfordSpezi/SpeziOnboarding) and [Spezi Consent](https://github.com/StanfordSpezi/SpeziConsent) modules.
        }
    }
    @Column {
        @Image(source: "https://raw.githubusercontent.com/StanfordSpezi/SpeziDevices/main/Sources/SpeziDevicesUI/SpeziDevicesUI.docc/Resources/PairedDevices.png", alt: "Screenshot displaying Spezi Devices and Bluetooth pairing user interface.") {
            The [Spezi Bluetooth](https://github.com/StanfordSpezi/SpeziBluetooth) and [Spezi Devices](https://github.com/StanfordSpezi/SpeziDevices) modules.
        }
    }
    @Column {
        @Image(source: "https://raw.githubusercontent.com/StanfordSpezi/SpeziQuestionnaire/main/Sources/SpeziQuestionnaire/SpeziQuestionnaire.docc/Resources/Overview.png", alt: "Screenshot displaying the UI of the questionnaire module.") {
            The [Spezi Questionnaire](https://github.com/StanfordSpezi/SpeziQuestionnaire) module.
        }
    }
}
@Row {
    @Column {
        @Image(source: "https://raw.githubusercontent.com/StanfordSpezi/SpeziAccount/main/Sources/SpeziAccount/SpeziAccount.docc/Resources/AccountSetup.png", alt: "Screenshot displaying the account setup view with email and password prompt and Sign In with Apple button using the Spezi Account module.") {
            The [Spezi Account](https://github.com/StanfordSpezi/SpeziAccount) module.
        }
    }
    @Column {
        @Image(source: "https://raw.githubusercontent.com/StanfordSpezi/SpeziViews/main/Sources/SpeziValidation/SpeziValidation.docc/Resources/Validation.png", alt: "Three different text fields showing validation errors with the Spezi Validation package.") {
            The [Spezi Views](https://github.com/StanfordSpezi/SpeziViews) module, including the [SpeziValidation](https://swiftpackageindex.com/StanfordSpezi/SpeziViews/documentation/spezivalidation) target.
        }
    }
    @Column {
        @Image(source: "https://raw.githubusercontent.com/StanfordSpezi/SpeziLLM/main/Sources/SpeziLLMLocal/SpeziLLMLocal.docc/Resources/ChatView.png", alt: "Chat view of a locally executed LLM using the Spezi LLM module.") {
            The [Spezi LLM](https://github.com/StanfordSpezi/SpeziLLM) module.
        }
    }
}

The best way to get started and explore Spezi’s functionality is by using the [Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication).
The application incorporates a wide range of modules and demonstrates their usage in a simple-to-use and easy-to-extend application.

### An Ecosystem of Modules

You can find a list of modules and reusable Swift packages offered by the Spezi team at Stanford on the [Swift Package Index Stanford Spezi page](https://swiftpackageindex.com/StanfordSpezi).

> Note: Spezi relies on an ecosystem of modules. Consider what modules you want to build and contribute to the open-source community. Refer to the <doc:Spezi-Guide> and <doc:Documentation-Guide> for requirements for Spezi-based software modules, and see the ``Module`` documentation to learn more about building your modules.

Learn more about Spezi at [spezi.stanford.edu](https://spezi.stanford.edu).
Connect with us on social media, and use the [Stanford Spezi Discussion Forum](https://github.com/orgs/StanfordSpezi/discussions) to ask any Spezi-related questions or share the projects you have built with Spezi.

Check out the [Stanford Biodesign Digital Health GitHub organization](https://github.com/StanfordBDHG) and the [Stanford Biodesign Digital Health website](https://bdh.stanford.edu) for applications built with Spezi and related open-source and research projects.

> Tip: You can find a complete list of the Swift-based Spezi modules on the [Spezi Swift Package Index](https://swiftpackageindex.com/StanfordSpezi) page.

### The Spezi Building Blocks

> Tip: The <doc:Spezi-Guide> and <doc:Documentation-Guide> guides outline the requirements for Spezi-based modules, including terminology, guidance, and examples on structuring your Spezi module, Swift package, and repository.

A ``Standard`` defines the key coordinator that orchestrates data flow in an application by meeting requirements defined by modules.
You can learn more about the ``Standard`` protocol and when it is advised to create your own standard in your application in the <doc:Standard> documentation.

A ``Module`` defines a software subsystem providing distinct and reusable functionality.
Modules can use the constraint mechanism to enforce a set of requirements for the standard used in the Spezi-based software where the module is used.
Modules also define dependencies on each other to reuse functionality and can communicate with other modules by offering and collecting information.
You can learn more about modules in the <doc:Module> documentation.

## Topics

### Configuration

- <doc:Initial-Setup>
- ``SpeziAppDelegate``
- ``Configuration``
- ``SwiftUICore/View/spezi(_:)-3bn89``

### Essential Concepts

- ``Spezi/Spezi``
- ``Standard``
- ``Module``

### Previews

- ``SwiftUICore/View/previewWith(standard:simulateLifecycle:_:)``
- ``SwiftUICore/View/previewWith(simulateLifecycle:_:)``
- ``Foundation/ProcessInfo/isPreviewSimulator``
- ``LifecycleSimulationOptions``

### Contribute to Spezi

- <doc:Contributing-Guide>
- <doc:Spezi-Guide>
- <doc:Documentation-Guide>
