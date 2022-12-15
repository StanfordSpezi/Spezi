//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct OnboardingActionsView: View {
    private let primaryText: String
    private let primaryAction: () -> Void
    private let seconaryText: String?
    private let seconaryAction: (() -> Void)?
    
    
    var body: some View {
        Button(action: primaryAction) {
            Text(primaryText)
                .frame(maxWidth: .infinity, minHeight: 38)
        }
            .buttonStyle(.borderedProminent)
        if let seconaryText, let seconaryAction {
            Button(seconaryText) {
                seconaryAction()
            }
                .padding(.top, 10)
        }
    }
    
    init<Text: StringProtocol>(
        _ text: Text,
        action: @escaping () -> Void
    ) {
        self.primaryText = text.localized
        self.primaryAction = action
        self.seconaryText = nil
        self.seconaryAction = nil
    }
    
    init<PrimaryText: StringProtocol, SeconaryText: StringProtocol>(
        primaryText: PrimaryText,
        primaryAction: @escaping () -> Void,
        seconaryText: SeconaryText,
        seconaryAction: (@escaping () -> Void)
    ) {
        self.primaryText = primaryText.localized
        self.primaryAction = primaryAction
        self.seconaryText = seconaryText.localized
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
