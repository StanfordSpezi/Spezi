# Displaying Information

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Display information to your user during an onboarding flow.

## OnboardingView

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

## SequentialOnboardingView

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

## Topics

### Views

- ``OnboardingView``
- ``SequentialOnboardingView``
