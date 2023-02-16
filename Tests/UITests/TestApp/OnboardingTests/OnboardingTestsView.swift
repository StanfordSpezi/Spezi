//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Onboarding
import SwiftUI


struct OnboardingTestsView: View {
    enum OnboardingStep: String, CaseIterable, Codable {
        case consentView = "Consent View"
        case onboardingView = "Onboarding View"
        case sequentialOnboarding = "Sequential Onboarding"
    }
    
    
    @Binding private var path: NavigationPath
    
    
    var body: some View {
        List(OnboardingStep.allCases, id: \.rawValue) { onboardingStep in
            NavigationLink(onboardingStep.rawValue, value: onboardingStep)
        }
            .navigationTitle("Onboarding")
            .navigationDestination(for: OnboardingStep.self) { onboardingStep in
                switch onboardingStep {
                case .consentView:
                    consentView
                case .onboardingView:
                    onboardingView
                case .sequentialOnboarding:
                    sequentialOnboardingView
                }
            }
    }
    
    
    private var consentView: some View {
        ConsentView(
            header: {
                OnboardingTitleView(title: "Consent", subtitle: "Version 1.0")
            },
            asyncMarkdown: {
                Data("This is a *markdown* **example**".utf8)
            },
            action: {
                path.append(OnboardingStep.onboardingView)
            }
        )
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var onboardingView: some View {
        OnboardingView(
            title: "Welcome",
            subtitle: "CardinalKit UI Tests",
            areas: [
                .init(icon: Image(systemName: "tortoise.fill"), title: "Tortoise", description: "A Tortoise!"),
                .init(icon: Image(systemName: "lizard.fill"), title: "Lizard", description: "A Lizard!"),
                .init(icon: Image(systemName: "tree.fill"), title: "Tree", description: "A Tree!")
            ],
            actionText: "Learn More",
            action: {
                path.append(OnboardingStep.sequentialOnboarding)
            }
        )
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var sequentialOnboardingView: some View {
        SequentialOnboardingView(
            title: "Things to know",
            subtitle: "And you should pay close attention ...",
            content: [
                .init(title: "A thing to know", description: "This is a first thing that you should know, read carfully!"),
                .init(title: "Second thing to know", description: "This is a second thing that you should know, read carfully!"),
                .init(title: "Third thing to know", description: "This is a third thing that you should know, read carfully!")
            ],
            actionText: "Continue"
        ) {
            path.append(OnboardingStep.consentView)
        }
            .navigationBarTitleDisplayMode(.inline)
    }
    
    
    init(navigationPath: Binding<NavigationPath>) {
        self._path = navigationPath
    }
}


#if DEBUG
struct OnboardingTestsView_Previews: PreviewProvider {
    @State private static var path = NavigationPath()
    
    
    static var previews: some View {
        NavigationStack {
            OnboardingTestsView(navigationPath: $path)
        }
    }
}
#endif
