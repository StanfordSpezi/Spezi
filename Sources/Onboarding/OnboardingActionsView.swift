//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct OnboardingActionsView: View {
    let primaryText: String.LocalizationValue
    let primaryAction: () -> Void
    let seconaryText: String.LocalizationValue?
    let seconaryAction: (() -> Void)?
    
    
    var body: some View {
        Button(action: primaryAction) {
            Text(String(localized: primaryText))
                .frame(maxWidth: .infinity, minHeight: 38)
        }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 10)
        if let seconaryText, let seconaryAction {
            Button(String(localized: seconaryText)) {
                seconaryAction()
            }
        }
    }
    
    init(
        _ text: String.LocalizationValue,
        action: @escaping () -> Void
    ) {
        self.primaryText = text
        self.primaryAction = action
        self.seconaryText = nil
        self.seconaryAction = nil
    }
    
    init(
        primaryText: String.LocalizationValue,
        primaryAction: @escaping () -> Void,
        seconaryText: String.LocalizationValue,
        seconaryAction: (@escaping () -> Void)
    ) {
        self.primaryText = primaryText
        self.primaryAction = primaryAction
        self.seconaryText = seconaryText
        self.seconaryAction = seconaryAction
    }
}

struct OnboardingActionsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OnboardingActionsView("PRIMARY") {
                print("Primary!")
            }
            OnboardingActionsView(
                primaryText: "PRIMARY",
                primaryAction: {
                    print("Primary")
                },
                seconaryText: "SECONDARY",
                seconaryAction: {
                    print("Seconary")
                }
            )
        }
    }
}
