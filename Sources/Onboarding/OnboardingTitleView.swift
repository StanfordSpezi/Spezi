//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// The ``OnboardingTitleView`` allows developers to present a unified style for the in an onboarding flow.
/// The ``OnboardingTitleView`` can contain one title and a optional subtitle below the title.
///
/// ```swift
/// OnboardingTitleView(title: "Title", subtitle: "Subtitle")
/// ```
public struct OnboardingTitleView: View {
    private let title: String
    private let subtitle: String?
    
    
    public var body: some View {
        VStack {
            Text(title)
                .bold()
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .padding(.top, 30)
            if let subtitle = subtitle {
                Text(subtitle)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
            }
        }
    }
    
    
    /// Creates an ``OnboardingActionsView`` instance that only contains a title.
    /// - Parameter title: The title of the ``OnboardingActionsView``.
    public init<S: StringProtocol>(title: S) {
        self.title = title.localized
        self.subtitle = nil
    }
    
    /// Creates an ``OnboardingActionsView`` instance that contains a title and a subtitle.
    /// - Parameters:
    ///   - title: The title of the ``OnboardingActionsView``.
    ///   - subtitle: The subtitle of the ``OnboardingActionsView``.
    public init<S1: StringProtocol, S2: StringProtocol>(title: S1, subtitle: S2?) {
        self.title = title.localized
        self.subtitle = subtitle?.localized
    }
}


#if DEBUG
struct OnboardingTitleView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTitleView(title: "Title", subtitle: "Subtitle")
    }
}
#endif
