//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct OnboardingView<TitleView: View, ContentView: View, ActionView: View>: View {
    let titleView: TitleView
    let contentView: ContentView
    let actionView: ActionView?
    
    
    var body: some View {
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
    
    
    init(
        @ViewBuilder titleView: () -> TitleView,
        @ViewBuilder contentView: () -> ContentView,
        @ViewBuilder actionView: () -> ActionView? = { nil }
    ) {
        self.titleView = titleView()
        self.contentView = contentView()
        self.actionView = actionView()
    }
    
    init(
        title: String.LocalizationValue,
        subtitle: String.LocalizationValue?,
        areas: [OnboardingInformationView.Content],
        actionText: String.LocalizationValue,
        action: @escaping () -> Void
    ) where TitleView == OnboardingTitleView, ContentView == OnboardingInformationView, ActionView == OnboardingActionsView {
        self.titleView = OnboardingTitleView(title: title, subtitle: subtitle)
        self.contentView = OnboardingInformationView(areas: areas)
        self.actionView = OnboardingActionsView(actionText) {
            action()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            title: "TITLE",
            subtitle: "SUBTITLE",
            areas: OnboardingInformationView.Content.mock,
            actionText: "PRIMARY"
        ) {
            print("Primary!")
        }
    }
}
