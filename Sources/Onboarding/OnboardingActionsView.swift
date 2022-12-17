//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


/// The ``OnboardingActionsView`` allows developers to present a unified style for action buttons in an onboarding flow.
/// The ``OnboardingActionsView`` can contain one primary button and a optional secondary button below the primary button.
///
/// ```
/// OnboardingActionsView(
///     primaryText: "Primary Text",
///     primaryAction: {
///         // ...
///     },
///     secondaryText: "Secondary Text",
///     secondaryAction: {
///         // ...
///     }
/// )
/// ```
public struct OnboardingActionsView: View {
    private let primaryText: String
    private let primaryAction: () -> Void
    private let secondaryText: String?
    private let secondaryAction: (() -> Void)?
    
    
    public var body: some View {
        Button(action: primaryAction) {
            Text(primaryText)
                .frame(maxWidth: .infinity, minHeight: 38)
        }
            .buttonStyle(.borderedProminent)
        if let secondaryText, let secondaryAction {
            Button(secondaryText) {
                secondaryAction()
            }
                .padding(.top, 10)
        }
    }
    
    /// Creates an ``OnboardingActionsView`` instance that only contains a primary button.
    /// - Parameters:
    ///   - text: The title ot the primary button.
    ///   - action: The action that should be performed when pressing the primary button
    public init<Text: StringProtocol>(
        _ text: Text,
        action: @escaping () -> Void
    ) {
        self.primaryText = text.localized
        self.primaryAction = action
        self.secondaryText = nil
        self.secondaryAction = nil
    }
    
    /// Creates an ``OnboardingActionsView`` instance that contains a primary button and a secondary button.
    /// - Parameters:
    ///   - primaryText: The title ot the primary button.
    ///   - primaryAction: The action that should be performed when pressing the primary button
    ///   - secondaryText: The title ot the secondary button.
    ///   - secondaryAction: The action that should be performed when pressing the secondary button
    public init<PrimaryText: StringProtocol, SecondaryText: StringProtocol>(
        primaryText: PrimaryText,
        primaryAction: @escaping () -> Void,
        secondaryText: SecondaryText,
        secondaryAction: (@escaping () -> Void)
    ) {
        self.primaryText = primaryText.localized
        self.primaryAction = primaryAction
        self.secondaryText = secondaryText.localized
        self.secondaryAction = secondaryAction
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
                secondaryText: "SECONDARY",
                secondaryAction: {
                    print("Seconary")
                }
            )
        }
    }
}
