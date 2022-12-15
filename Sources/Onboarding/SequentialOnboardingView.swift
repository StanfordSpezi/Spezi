//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// <#Description#>
public struct SequentialOnboardingView: View {
    /// <#Description#>
    public struct Content {
        /// <#Description#>
        public let title: String
        /// <#Description#>
        public let description: String
        
        
        /// <#Description#>
        /// - Parameters:
        ///   - title: <#title description#>
        ///   - description: <#description description#>
        public init<Title: StringProtocol, Description: StringProtocol>(
            title: Title,
            description: Description
        ) {
            self.title = title.localized
            self.description = description.localized
        }
    }
    
    
    private let titleView: AnyView
    private let content: [Content]
    @State private var currentContentIndex: Int = 0
    private let actionText: String
    private let action: () -> Void
    
    
    public var body: some View {
        ScrollViewReader { proxy in
            OnboardingView(
                titleView: {
                    titleView
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
                    OnboardingActionsView(
                        actionButtonTitle
                    ) {
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
    
    private var actionButtonTitle: String {
        if currentContentIndex < content.count - 1 {
            return String(localized: "SEQUENTIAL_ONBOARDING_NEXT", bundle: .module)
        } else {
            return actionText
        }
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - subtitle: <#subtitle description#>
    ///   - content: <#content description#>
    ///   - actionText: <#actionText description#>
    ///   - action: <#action description#>
    public init<Title: StringProtocol, Subtitle: StringProtocol, ActionText: StringProtocol>(
        title: Title,
        subtitle: Subtitle?,
        content: [Content],
        actionText: ActionText,
        action: @escaping () -> Void
    ) {
        self.init(
            titleView: OnboardingTitleView(title: title, subtitle: subtitle),
            content: content,
            actionText: actionText,
            action: action
        )
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - titleView: <#titleView description#>
    ///   - content: <#content description#>
    ///   - actionText: <#actionText description#>
    ///   - action: <#action description#>
    public init<TitleView: View, ActionText: StringProtocol>(
        titleView: TitleView,
        content: [Content],
        actionText: ActionText,
        action: @escaping () -> Void
    ) {
        self.titleView = AnyView(titleView)
        self.content = content
        self.actionText = actionText.localized
        self.action = action
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
                    Text(content.title)
                        .bold()
                    Text(content.description)
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
    static var mock: [SequentialOnboardingView.Content] {
        [
            .init(title: "A thing to know", description: "This is a first thing that you should know, read carfully!"),
            .init(title: "Second thing to know", description: "This is a second thing that you should know, read carfully!"),
            .init(title: "Third thing to know", description: "This is a third thing that you should know, read carfully!")
        ]
    }
    
    static var previews: some View {
        SequentialOnboardingView(
            title: "Title",
            subtitle: "Subtitle",
            content: mock,
            actionText: "Continue"
        ) {
            print("Done!")
        }
    }
}
