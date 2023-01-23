# ``Onboarding``

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Provides SwiftUI views for onboarding users onto a digital health application.

## Onboarding

The ``Onboarding`` module provides views that can be used for performing onboarding tasks, such as providing an overview of your app and asking a user to read and sign a consent document.

Begin by importing the module into your SwiftUI file:

```swift
import Onboarding
```

### Displaying Information

The Onboarding module provides two methods of displaying information to your user. 

The ``OnboardingView`` allows you to separate information into areas on a screen, each with a title, description, and icon.

![OnboardingView](OnboardingView.png)

The following example demonstrates how the above view is constructed:

```swift
OnboardingView(
    title: "Welcome",
    subtitle: "CardinalKit UI Tests",
    areas: [
        .init(
            icon: Image(systemName: "tortoise.fill"), 
            title: "Tortoise", 
            description: "A Tortoise!"
        ),
        .init(
            icon: Image(systemName: "lizard.fill"), 
            title: "Lizard", 
            description: "A Lizard!"
        ),
        .init(
            icon: Image(systemName: "tree.fill"), 
            title: "Tree", 
            description: "A Tree!"
        )
    ],
    actionText: "Learn More",
    action: {
        // Action to perform when the user taps the action button.
    }
```

The ``SequentialOnboardingView`` allows you to display information step-by-step with each additional area appearing when the user taps the `Continue` button.

![SequentialOnboardingView](SequentialOnboardingView.png)

The following example demonstrates how the above view is constructed:

```swift
SequentialOnboardingView(
    title: "Things to know",
    subtitle: "And you should pay close attention ...",
    content: [
        .init(
            title: "A thing to know", 
            description: "This is a first thing that you should know, read carefully!"
        ),
        .init(
            title: "Second thing to know", 
            description: "This is a second thing that you should know, read carefully!"
        ),
        .init(
            title: "Third thing to know", 
            description: "This is a third thing that you should know, read carefully!"
        )
    ],
    actionText: "Continue"
) {
    // Action to perform when the user has viewed all the steps
}
```

### Obtaining User Consent

The ``ConsentView`` can be used to allow your users to read and agree to a document, e.g. a consent document for a research study or a terms and conditions document for an app. The document can be signed using a family and given name, and a hand drawn signature. 

![ConsentView](ConsentView.png)

The following example demonstrates how the ``ConsentView`` shown above is constructed by providing a header, markdown content encoded as a UTF8 `Data` instance (which may be provided asynchronously), and an action that should be performed once the consent has been given.

```swift
ConsentView(
    header: {
        OnboardingTitleView(title: "Consent", subtitle: "Version 1.0")
    },
    asyncMarkdown: {
        Data("This is a *markdown* **example**".utf8)
    },
    action: {
        // Action to perform once the user has given their consent
    }
)
```

## Topics

### Views

- ``ConsentView``
- ``OnboardingActionsView``
- ``OnboardingInformationView``
- ``OnboardingTitleView``
- ``OnboardingView``
- ``SequentialOnboardingView``
- ``SignatureView``
