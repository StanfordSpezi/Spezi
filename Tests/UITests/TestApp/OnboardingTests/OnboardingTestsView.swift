//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
@testable import Onboarding
import SwiftUI


struct OnboardingTestsView: View {
    enum OnboardingStep: String, CaseIterable, Codable {
        case consentView = "Consent View"
        case onboardingView = "Onboarding View"
        case sequentialOnboarding = "Sequential Onboarding"
    }
    
    
    @State private var isDrawing = false
    @State private var steps: [OnboardingStep] = []
    
    
    var body: some View {
        NavigationStack(path: $steps) {
            List(OnboardingStep.allCases, id: \.rawValue) { onboardingStep in
                NavigationLink(onboardingStep.rawValue, value: onboardingStep)
            }
                .navigationDestination(for: OnboardingStep.self) { onboardingStep in
                    switch onboardingStep {
                    case .consentView:
                        consentView
                            .navigationTitle(onboardingStep.rawValue)
                    case .onboardingView:
                        onboardingView
                            .navigationTitle(onboardingStep.rawValue)
                    case .sequentialOnboarding:
                        sequentialOnboardingView
                            .navigationTitle(onboardingStep.rawValue)
                    }
                }
        }
    }
    
    
    private var consentView: some View {
        ConsentView(
            titleView: {
                OnboardingTitleView(title: "Consent", subtitle: "Version 1.0")
            },
            asyncMarkdown: {
                Data("This is a *markdown* **example**".utf8)
            },
            action: {
                steps.append(.onboardingView)
            }
        )
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
                steps.append(.sequentialOnboarding)
            }
        )
    }
    
    private var sequentialOnboardingView: some View {
        SequentialOnboardingView(
            title: "Title",
            subtitle: "Subtitle",
            content: [
                .init(title: "A thing to know", description: "This is a first thing that you should know, read carfully!"),
                .init(title: "Second thing to know", description: "This is a second thing that you should know, read carfully!"),
                .init(title: "Third thing to know", description: "This is a third thing that you should know, read carfully!")
            ],
            actionText: "Continue"
        ) {
            steps.append(.consentView)
        }
    }
}


struct OnboardingTestsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OnboardingTestsView()
        }
    }
}
