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
import Views


struct OnboardingTestsView: View {
    enum OnboardingStep: String, CaseIterable, Codable {
        case consentMarkdownView = "Consent View (Markdown)"
        case consentHTMLView = "Consent View (HTML)"
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
                case .consentMarkdownView:
                    consentMarkdownView
                case .consentHTMLView:
                    consentHTMLView
                case .onboardingView:
                    onboardingView
                case .sequentialOnboarding:
                    sequentialOnboardingView
                }
            }
    }

    private var consentMarkdownView: some View {
        ConsentView(
            header: {
                OnboardingTitleView(title: "Consent", subtitle: "Version 1.0")
            },
            asyncMarkdown: {
                Data("This is a *markdown* **example**".utf8)
            },
            action: {
                path.append(OnboardingStep.onboardingView)
            },
            givenNameField: FieldLocalization(title: "First Name", placeholder: "Enter your first name ..."),
            familyNameField: FieldLocalization(title: "Surname", placeholder: "Enter your surname ...")
        )
            .navigationBarTitleDisplayMode(.inline)
    }

    private var consentHTMLView: some View {
        ConsentView(
            header: {
                OnboardingTitleView(title: "Consent", subtitle: "Version 1.0")
            },
            asyncHTML: {
                try? await Task.sleep(for: .seconds(2))
                let html = """
                        <meta name=\"viewport\" content=\"initial-scale=1.0\" />
                        <h1>Study Consent</h1>
                        <hr />
                        <p>This is an example of a study consent written in HTML.</p>
                        <h2>Study Tasks</h2>
                        <ul>
                            <li>First task</li>
                            <li>Second task</li>
                            <li>Third task</li>
                        </ul>
                """
                return Data(html.utf8)
            },
            action: {
                path.append(OnboardingStep.onboardingView)
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
            path.append(OnboardingStep.consentMarkdownView)
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
