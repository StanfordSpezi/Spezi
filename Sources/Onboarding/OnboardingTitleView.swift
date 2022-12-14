//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct OnboardingTitleView: View {
    let title: String.LocalizationValue
    let subtitle: String.LocalizationValue?
    
    
    var body: some View {
        VStack {
            Text(String(localized: title))
                .bold()
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .padding(.top, 30)
            
            if let subtitle = subtitle {
                Text(String(localized: subtitle))
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
            }
        }
    }
}

struct OnboardingTitleView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTitleView(title: "TITLE", subtitle: "SUBTITLE")
    }
}
