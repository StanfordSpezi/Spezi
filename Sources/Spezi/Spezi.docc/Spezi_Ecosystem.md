# The Spezi Ecosystem

<!--
This source file is part of the Stanford Spezi open-source project
SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
SPDX-License-Identifier: MIT
-->

Discover the core modules available in the Spezi framework and understand their use cases.

## Overview

The Spezi ecosystem provides a collection of interoperable modules designed to accelerate healthcare and research application development. Each module is built to work independently or in combination with others, allowing you to choose the components that best fit your needs.

## Core Modules
Some of the following modules can be tested and interact with using the Template Application: **[SpeziTemplate](https://github.com/StanfordSpezi/SpeziTemplateApplication)**

### Spezi Onboarding
- **[SpeziOnboarding](https://github.com/StanfordSpezi/SpeziOnboarding)**
    - [SpeziOnboarding Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziOnboarding/1.2.2/documentation/spezionboarding) 
    - Use Case: this Module helps to 
    - Features:
        - Welcome screen 
        - Sequential Onboarding screens
        - Consent screen to allow users to read and agree to a document
    - this module is included and demonstratedin the Template Application 

### User Management
- **[SpeziAccount](https://github.com/StanfordSpezi/SpeziAccount)**
    - [SpeziAccount Documentation](https://swiftpackageindex.com/stanfordspezi/speziaccount/main/documentation/speziaccount) 
    - Use Case: this Module helps to configure users and helps to manage authentication 
    - Features:
        - User login and authentication 
        - New account Creation for user login 
        - User Account overview and profile management Capabilities
    - this module is included and demonstratedin the Template Application 

### Connected Devices
- **[SpeziDevices](https://github.com/StanfordSpezi/SpeziDevices)**
    - [SpeziDevices Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziDevices/1.5.0/documentation/spezidevices) 
    - Use Case: this Module helps to /////////////////////// hier die funktion klar stellen -> ist es nun supporting oder nicht? 
    - Features:
        - 
        -    // hilfreich: https://github.com/StanfordSpezi/SpeziDevices
        - 

### Spezi Bluetooth // seems to be the "core module" and ###connected devices rather a supporter of this module // unsicher
- **[SpeziBluetooth](https://github.com/StanfordSpezi/SpeziBluetooth)** // unsicher
    - [SpeziBluetooth Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziBluetooth/main/documentation/spezibluetooth) 
    - Use Case: this Module helps to /////////////////////// hier noch 
    - Features:
        - Discovery of Bluetooth devices
        - Configuration and Declaration of Bluetooth devices

### Cloud Systems
- **[SpeziFirebase](https://github.com/StanfordSpezi/SpeziFirebase)**
    - [SpeziOnboarding Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziFirebase/main/documentation/spezifirebaseaccount) 
    - Use Case: this Module helps to enable the interaction with Google Firebase for a managed backend authentication and data storage
    - Features:
        - 
        - /////////////////////// hier noch 
        - 
    - this module is included and demonstratedin the Template Application 

### Electronic Health Integration
- **[SpeziFHIR](https://github.com/StanfordSpezi/SpeziFHIR)**
    - [SpeziFHIR Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziFHIR/main/documentation/spezifhir) 
    - Use Case: this Module helps to 
    - Features:
        - 
        -  /////////////////////// hier noch 
        - 

### LLMs and AI Integration
This includes three submodules:
- **[SpeziChat](https://github.com/StanfordSpezi/SpeziChat)**
    - [SpeziChat Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziChat/0.2.2/documentation/spezichat) 
    - Use Case: this Module helps to 
    - Features:
        - 
        -  /////////////////////// hier noch 
        - 

- **[SpeziSpeech](https://github.com/StanfordSpezi/SpeziSpeech)**
    - [SpeziSpeech Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziSpeech/1.1.1/documentation/spezispeechrecognizer) 
    - Use Case: this Module helps to 
    - Features:
        - 
        -  /////////////////////// hier noch 
        - 

- **[SpeziLLM](https://github.com/StanfordSpezi/SpeziLLM)**
    - [SpeziLLM Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziLLM/main/documentation/spezillm) 
    - Use Case: this Module helps to 
    - Features:
        - 
        -  /////////////////////// hier noch 
        - 

### Local Data Storage
- **[SpeziStorage](https://github.com/StanfordSpezi/SpeziStorage)**
    - [SpeziStorage Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziStorage/main/documentation/spezilocalstorage) 
    - Use Case: this Module helps to 
    - Features:
        - 
        - 
        - 
    - this module is included and demonstratedin the Template Application 

### Mobile Health Data 
- **[SpeziAccount](https://github.com/StanfordSpezi/SpeziAccount)**
    - [SpeziAccount Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziAccount/main/documentation/speziaccount) 
    - Use Case: this Module helps to 
    - Features:
        - 
        - 
        - 
    - this module is included and demonstratedin the Template Application 

### Spezi Questionnaire
- **[SpeziQuestionnaire](https://github.com/StanfordSpezi/SpeziQuestionnaire)**
    - [SpeziQuestionnaire Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziQuestionnaire/1.2.3/documentation/speziquestionnaire) 
    - Use Case: this Module helps to 
    - Features:
        - 
        - 
        - 
    - this module is included and demonstratedin the Template Application 

### Tasks and Reminders
- **[SpeziScheduler](https://github.com/StanfordSpezi/SpeziScheduler)**
    - [SpeziScheduler Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziScheduler/1.1.0/documentation/spezischeduler) 
    - Use Case: this Module helps to 
    - Features:
        - 
        - 
        - 
    - this module is included and demonstratedin the Template Application 

---- 
### SpeziAccessGuard

### Spezi Contact

### Spezi HealthKit

### Spezi Medication 




## Getting Started

To use any Spezi module:

1. Add it to your `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/StanfordSpezi/Spezi.git", .upToNextMinor(from: "0.5.0")),
    .package(url: "https://github.com/StanfordSpezi/[ModuleName].git", .upToNextMinor(from: "0.5.0"))
]
```

2. Import the module in your code:
```swift
import Spezi
import SpeziAccount  // Or other module name
```

For detailed setup instructions, see <doc:Understanding-Spezi>.

## Topics

### Essential Reading
- <doc:Understanding-Spezi>
- <doc:Initial-Setup>
- <doc:Contributing-Guide>

### Module Development
- <doc:Spezi-Guide>
- <doc:Documentation-Guide>
- ``Module``
