//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct UsernamePasswordResetPasswordView: View {
    private let usernameValidationRules: [ValidationRule]
    private let header: AnyView
    private let footer: AnyView
    
    @EnvironmentObject private var usernamePasswordAccountService: UsernamePasswordAccountService
    
    @State private var username: String = ""
    @State private var valid = false
    @FocusState private var focusedField: AccountInputFields?
    @State private var state: AccountViewState = .idle
    
    private let localization: ConfigurableLocalization<Localization.ResetPassword>
    
    
    var body: some View {
        ScrollView {
            header
            Divider()
            Text("Reset Password!")
            Divider()
            resetPasswordButton
            footer
        }
            .navigationTitle(navigationTitle)
            .navigationBarBackButtonHidden(state == .processing)
            .onTapGesture {
                focusedField = nil
            }
            .viewStateAlert(state: $state)
    }
    
    
    private var resetPasswordButton: some View {
        let resetPasswordButtonDisabled = state == .processing || !valid
        let resetPasswordButtonTitleLocalization: String
        switch localization {
        case .environment:
            resetPasswordButtonTitleLocalization = usernamePasswordAccountService.localization.resetPassword.resetPasswordActionbuttonTitle
        case let .value(resetPassword):
            resetPasswordButtonTitleLocalization = resetPassword.resetPasswordActionbuttonTitle
        }
        
        return Button(action: resetPasswordButtonPressed) {
            Text(resetPasswordButtonTitleLocalization)
                .padding(6)
                .frame(maxWidth: .infinity)
                .opacity(state == .processing ? 0.0 : 1.0)
                .overlay {
                    if state == .processing {
                        ProgressView()
                    }
                }
        }
            .buttonStyle(.borderedProminent)
            .disabled(resetPasswordButtonDisabled)
            .padding()
    }
    
    private var navigationTitle: String {
        switch localization {
        case .environment:
            return usernamePasswordAccountService.localization.resetPassword.navigationTitle
        case let .value(resetPassword):
            return resetPassword.navigationTitle
        }
    }
    
    
    init<Header: View, Footer: View>(
        usernameValidationRules: [ValidationRule] = [],
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder footer: () -> Footer = { EmptyView() },
        localization: ConfigurableLocalization<Localization.ResetPassword> = .environment
    ) {
        self.usernameValidationRules = usernameValidationRules
        self.header = AnyView(header())
        self.footer = AnyView(footer())
        self.localization = localization
    }
    
    
    private func resetPasswordButtonPressed() {
        guard !(state == .processing) else {
            return
        }
        
        withAnimation(.easeOut(duration: 0.2)) {
            focusedField = .none
            state = .processing
        }
        
        Task {
            do {
                try await usernamePasswordAccountService.resetPassword(username: username)
                withAnimation(.easeIn(duration: 0.2)) {
                    state = .idle
                }
            } catch {
                state = .error(error)
            }
        }
    }
}


struct UsernamePasswordResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UsernamePasswordResetPasswordView()
                .environmentObject(UsernamePasswordAccountService())
        }
    }
}
