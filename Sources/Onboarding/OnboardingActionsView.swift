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
/// ```swift
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
    private let _primaryAction: () async -> Void
    private let secondaryText: String?
    private let _secondaryAction: (() async -> Void)?
    
    @State private var primaryActionLoading = false
    @State private var secondaryActionLoading = false
    
    
    public var body: some View {
        VStack {
            Button(action: primaryAction) {
                Group {
                    if primaryActionLoading {
                        ProgressView()
                    } else {
                        Text(primaryText)
                    }
                }
                    .frame(maxWidth: .infinity, minHeight: 38)
            }
                .buttonStyle(.borderedProminent)
            if let secondaryText, _secondaryAction != nil {
                Button(action: secondaryAction) {
                    Group {
                        if secondaryActionLoading {
                            ProgressView()
                        } else {
                            Text(secondaryText)
                        }
                    }
                }
                    .padding(.top, 10)
            }
        }
            .disabled(primaryActionLoading || secondaryActionLoading)
    }
    
    /// Creates an ``OnboardingActionsView`` instance that only contains a primary button.
    /// - Parameters:
    ///   - text: The title ot the primary button.
    ///   - action: The action that should be performed when pressing the primary button
    public init<Text: StringProtocol>(
        _ text: Text,
        action: @escaping () async -> Void
    ) {
        self.primaryText = text.localized
        self._primaryAction = action
        self.secondaryText = nil
        self._secondaryAction = nil
    }
    
    /// Creates an ``OnboardingActionsView`` instance that contains a primary button and a secondary button.
    /// - Parameters:
    ///   - primaryText: The title ot the primary button.
    ///   - primaryAction: The action that should be performed when pressing the primary button
    ///   - secondaryText: The title ot the secondary button.
    ///   - secondaryAction: The action that should be performed when pressing the secondary button
    public init<PrimaryText: StringProtocol, SecondaryText: StringProtocol>(
        primaryText: PrimaryText,
        primaryAction: @escaping () async -> Void,
        secondaryText: SecondaryText,
        secondaryAction: (@escaping () async -> Void)
    ) {
        self.primaryText = primaryText.localized
        self._primaryAction = primaryAction
        self.secondaryText = secondaryText.localized
        self._secondaryAction = secondaryAction
    }
    
    
    private func primaryAction() {
        Task {
            withAnimation(.easeOut(duration: 0.2)) {
                primaryActionLoading = true
            }
            await _primaryAction()
            withAnimation(.easeIn(duration: 0.2)) {
                primaryActionLoading = false
            }
        }
    }
    
    private func secondaryAction() {
        Task {
            withAnimation(.easeOut(duration: 0.2)) {
                secondaryActionLoading = true
            }
            await _secondaryAction?()
            withAnimation(.easeIn(duration: 0.2)) {
                secondaryActionLoading = false
            }
        }
    }
}


#if DEBUG
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
#endif
