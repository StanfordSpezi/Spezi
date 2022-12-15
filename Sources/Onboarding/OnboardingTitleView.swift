//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// <#Description#>
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
    
    
    /// <#Description#>
    /// - Parameter title: <#title description#>
    public init<S: StringProtocol>(title: S) {
        self.title = title.localized
        self.subtitle = nil
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - subtitle: <#subtitle description#>
    public init<S1: StringProtocol, S2: StringProtocol>(title: S1, subtitle: S2?) {
        self.title = title.localized
        self.subtitle = subtitle?.localized
    }
}


struct OnboardingTitleView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTitleView(title: "Title", subtitle: "Subtitle")
    }
}
