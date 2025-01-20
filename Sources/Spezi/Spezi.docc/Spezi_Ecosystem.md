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
    - Use Case: This module handles user onboarding and initial registration flows. 
    - Features:
        - Welcome screen 
        - Sequential onboarding screens
        - Consent screen for users to read and agree to documents
    - This module is included and demonstrated in the Template Application. 

### User Management
- **[SpeziAccount](https://github.com/StanfordSpezi/SpeziAccount)**
    - [SpeziAccount Documentation](https://swiftpackageindex.com/stanfordspezi/speziaccount/main/documentation/speziaccount) 
    - Use Case: This module manages user configuration and authentication processes. 
    - Features:
        - User login and authentication 
        - New account creation 
        - Account overview and profile management 
    - This module is included and demonstrated in the Template Application.

### Connected Devices
- **[SpeziDevices](https://github.com/StanfordSpezi/SpeziDevices)**
    - [SpeziDevices Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziDevices/1.5.0/documentation/spezidevices) 
    - Use Case: This module enables seamless integration of Bluetooth-connected devices.
    - Features:
        - Device Connection Management
        - Data exchange between the app and connected devices  
        - Seamless integration with SpeziBluetooth module
    Note: SpeziDevices focuses on managing device connections via Bluetooth capabilities. SpeziBluetooth provides the infrastructure for the communication between devices.

### Spezi Bluetooth 
- **[SpeziBluetooth](https://github.com/StanfordSpezi/SpeziBluetooth)** 
    - [SpeziBluetooth Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziBluetooth/main/documentation/spezibluetooth) 
    - Use Case: This module provides the infrastructure for Bluetooth-based device communication.
    - Features:
        - Discovery of Bluetooth devices
        - Configuration and declaration of Bluetooth devices
        - Device status management
        - Data transmission via Bluetooth
    Note: SpeziDevices is a higher-level module that depends on the core Bluetooth connectivity offered by SpeziBluetooth. Together, they enable seamless interaction with Bluetooth devices.

### Cloud Systems
- **[SpeziFirebase](https://github.com/StanfordSpezi/SpeziFirebase)**
    - [SpeziFirebase Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziFirebase/main/documentation/spezifirebaseaccount) 
    - Use Case: This module enables Google Firebase integration for backend authentication and data storage.
    - Features:
        - Firebase authentication integration
        - Database storage and retrieval 
        - Synchronization of user data across devices
    - This module is included and demonstrated in the Template Application.

### Electronic Health Integration
- **[SpeziFHIR](https://github.com/StanfordSpezi/SpeziFHIR)**
    - [SpeziFHIR Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziFHIR/main/documentation/spezifhir) 
    - Use Case: This module supports management and processing of FHIR (Fast Healthcare Interoperability Resources).
    - Features:
        - Storage and management of FHIR resources
        - Automatic categorization and update of healthcare data
        - Interoperability with healthcare systems and applications

### LLMs and AI Integration
This includes three submodules:
- **[SpeziChat](https://github.com/StanfordSpezi/SpeziChat)**
    - [SpeziChat Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziChat/0.2.2/documentation/spezichat) 
    - Use Case: This module implements chat-based user interfaces for interaction.
    - Features:
        - Chat interface creation
        - Message history management
        - Integration with AI for natural language processing 

- **[SpeziSpeech](https://github.com/StanfordSpezi/SpeziSpeech)**
    - [SpeziSpeech Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziSpeech/1.1.1/documentation/spezispeechrecognizer) 
    - Use Case: This module provides speech-to-text and text-to-speech capabilities.
    - Features:
        - Speech synthesis (text-to-speech)
        - Speech recognition (speech-to-text)
        - Session management for speech input/output

- **[SpeziLLM](https://github.com/StanfordSpezi/SpeziLLM)**
    - [SpeziLLM Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziLLM/main/documentation/spezillm) 
    - Use Case: This module integrates large language models for AI-driven functionalities.
    - Features:
        - LLM-based text generation
        - Contextual understanding for complex queries

### Local Data Storage
- **[SpeziStorage](https://github.com/StanfordSpezi/SpeziStorage)**
    - [SpeziStorage Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziStorage/main/documentation/spezilocalstorage) 
    - Use Case: This module enables local storage capabilities for application data.
    - Features:
        - Data persistence
        - Efficient retrieval and management
        - Seamless integration with other modules
    - This module is included and demonstrated in the Template Application.

### Mobile Health Data 
- **[SpeziHealthKit](https://github.com/StanfordSpezi/SpeziHealthKit)**
    - [SpeziHealthKit Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziHealthKit/0.6.0/documentation/spezihealthkit) 
    - Use Case: This module simplifies access to HealthKit samples, supporting single, anchored, and background queries.
    - Features:
        - Simplified retrieval of HealthKit data samples
        - Support for anchored and background queries to monitor health data changes
        - Customizable data collection parameters 
    - This module is included and demonstrated in the Template Application.

### Spezi Questionnaire
- **[SpeziQuestionnaire](https://github.com/StanfordSpezi/SpeziQuestionnaire)**
    - [SpeziQuestionnaire Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziQuestionnaire/1.2.3/documentation/speziquestionnaire) 
    - Use Case: This module implements questionnaire features for user input.
    - Features:
        - Customizable questionnaire forms
        - Data capture and management
        - Integration with health or research applications
    - This module is included and demonstrated in the Template Application.

### Tasks and Reminders
- **[SpeziScheduler](https://github.com/StanfordSpezi/SpeziScheduler)**
    - [SpeziScheduler Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziScheduler/1.1.0/documentation/spezischeduler) 
    - Use Case: This module manages task scheduling and reminders within applications.
    - Features:
        - Task creation and management
        - Reminder notifications
        - Integration with other modules for seamless user experience
    - This module is included and demonstrated in the Template Application.

### Spezi AccessGuard
- **[SpeziAccessGuard](https://github.com/StanfordSpezi/SpeziAccessGuard)**
    - [SpeziAccessGuard Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziAccessGuard/0.3.2/documentation/speziaccessguard) 
    - Use Case: This module allows developers to easily guard a SwiftUI view with an access code or biometrics.
    - Features:
        - 4-digit numeric access code protection
        - Biometric authentication support (e.g., Face ID, Touch ID) with access code fallback
        - Customizable timeout settings for automatic locking
        - Functionality to set, reset, and manage access codes
    
### Spezi Contact
- **[SpeziContact](https://github.com/StanfordSpezi/SpeziContact)**
    - [SpeziContact Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziContact/1.0.2/documentation/spezicontact) 
    - Use Case: This module facilitates the display of contact information within applications.
    - Features:
        - Presentation of contact details, including names, phone numbers, and email addresses
        - Customization options for contact information display
    - This module is included and demonstrated in the Template Application.

### Spezi Medication 
- **[SpeziMedication](https://github.com/StanfordSpezi/SpeziMedication)**
    - [SpeziMedication Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziMedication/0.4.2/documentation/spezimedication) 
    - Use Case: This module helps with the display, editing, and management of medications, including dosages and schedules.
    - Features:
        - Display of current medications with detailed information
        - Editing capabilities for medication details, dosages, and schedules
        - Management of medication lists, including addition and removal of medications

### Spezi Notifications
- **[SpeziNotifications](https://github.com/StanfordSpezi/SpeziNotifications)**
    - [SpeziNotifications Documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziNotifications/main/documentation/spezinotifications) 
    - Use Case: This module simplifies the implementation of user notifications in Spezi-based applications.
    - Features:
        - Scheduling of local notifications 
        - Customization of notification content, including titles, messages, and triggers
        - Management of notification permissions and settings


