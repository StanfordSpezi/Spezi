//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct SequentialOnboardingView: View {
    struct Content {
        let title: String.LocalizationValue
        let description: String.LocalizationValue
        
        
        static var mock: [Content] {
            [
                Content(title: "A thing to know", description: "This is a first thing that you should know, read carfully!"),
                Content(title: "Second thing to know", description: "This is a second thing that you should know, read carfully!"),
                Content(title: "Third thing to know", description: "This is a third thing that you should know, read carfully!")
            ]
        }
    }
    
    let title: String.LocalizationValue
    let subtitle: String.LocalizationValue?
    let content: [Content]
    @State var currentContentIndex: Int = 0
    let actionText: String.LocalizationValue
    let action: () -> Void
    
    
    var body: some View {
        ScrollViewReader { proxy in
            OnboardingView(
                titleView: {
                    OnboardingTitleView(title: title, subtitle: subtitle)
                },
                contentView: {
                    ForEach(0..<content.count, id: \.self) { index in
                        if index <= currentContentIndex {
                            stepView(index: index)
                                .id(index)
                        }
                    }
                },
                actionView: {
                    OnboardingActionsView(currentContentIndex < content.count - 1 ? "SEQUENTIAL_ONBOARDING_NEXT" : actionText) {
                        if currentContentIndex < content.count - 1 {
                            currentContentIndex += 1
                            withAnimation {
                                proxy.scrollTo(currentContentIndex - 1, anchor: .top)
                            }
                        } else {
                            action()
                        }
                    }
                }
            )
        }
    }
    
    
    private func stepView(index: Int) -> some View {
        let content = content[index]
        return HStack {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(index + 1)")
                    .bold()
                    .foregroundColor(.white)
                    .padding(12)
                    .background {
                        Circle()
                            .fill(Color.accentColor)
                    }
                VStack(alignment: .leading, spacing: 8) {
                    Text(String(localized: content.title))
                        .bold()
                    Text(String(localized: content.description))
                }
                Spacer()
            }
                .padding(.horizontal, 12)
                .padding(.top, 4)
                .padding(.bottom, 12)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGroupedBackground))
                }
        }
    }
}


struct SequentialOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        SequentialOnboardingView(title: "TITLE", subtitle: "SUBTITLE", content: SequentialOnboardingView.Content.mock, actionText: "ACTION") {
            print("Done!")
        }
    }
}
