//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// <#Description#>
public struct OnboardingView<TitleView: View, ContentView: View, ActionView: View>: View {
    private let titleView: TitleView
    private let contentView: ContentView
    private let actionView: ActionView?
    
    
    public var body: some View {
        Group {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center) {
                        VStack {
                            titleView
                            contentView
                        }
                        if let actionView {
                            Spacer()
                            actionView
                        }
                        Spacer()
                            .frame(height: 10)
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
            .padding(24)
        }
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - titleView: <#titleView description#>
    ///   - contentView: <#contentView description#>
    ///   - actionView: <#actionView description#>
    public init(
        @ViewBuilder titleView: () -> TitleView,
        @ViewBuilder contentView: () -> ContentView,
        @ViewBuilder actionView: () -> ActionView? = { nil }
    ) {
        self.titleView = titleView()
        self.contentView = contentView()
        self.actionView = actionView()
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - subtitle: <#subtitle description#>
    ///   - areas: <#areas description#>
    ///   - actionText: <#actionText description#>
    ///   - action: <#action description#>
    public init(
        title: String,
        subtitle: String?,
        areas: [OnboardingInformationView.Content],
        actionText: String,
        action: @escaping () -> Void
    ) where TitleView == OnboardingTitleView, ContentView == OnboardingInformationView, ActionView == OnboardingActionsView {
        self.init(
            titleView: {
                OnboardingTitleView(title: title, subtitle: subtitle)
            },
            contentView: {
                OnboardingInformationView(areas: areas)
            }, actionView: {
                OnboardingActionsView(actionText) {
                    action()
                }
            }
        )
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            title: "Title",
            subtitle: "Subtitle",
            areas: AreasView_Previews.mock,
            actionText: "Primary Button"
        ) {
            print("Primary!")
        }
    }
}
