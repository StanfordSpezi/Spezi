//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct UsernamePasswordLoginView: View {
    private let usernameValidationRules: [ValidationRule]
    private let passwordValidationRules: [ValidationRule]
    private let header: AnyView
    private let footer: AnyView
    
    @EnvironmentObject private var usernamePasswordLoginService: UsernamePasswordAccountService
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var valid = false
    @FocusState private var focusedField: AccountInputFields?
    @State private var state: AccountViewState = .idle
    
    private let localization: ConfigurableLocalization<Localization.Login>
    
    
    var body: some View {
        ScrollView {
            header
            Divider()
            usernamePasswordSection
            Divider()
            loginButton
            footer
        }
            .navigationTitle(navigationTitle)
            .navigationBarBackButtonHidden(state == .processing)
            .onTapGesture {
                focusedField = nil
            }
            .viewStateAlert(state: $state)
    }
    
    private var usernamePasswordSection: some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 16) {
            switch localization {
            case .environment:
                UsernamePasswordFields(
                    username: $username,
                    password: $password,
                    valid: $valid,
                    focusState: _focusedField,
                    usernameValidationRules: usernameValidationRules,
                    passwordValidationRules: passwordValidationRules,
                    presentationType: .login(.environment)
                )
            case let .value(login):
                UsernamePasswordFields(
                    username: $username,
                    password: $password,
                    valid: $valid,
                    focusState: _focusedField,
                    usernameValidationRules: usernameValidationRules,
                    passwordValidationRules: passwordValidationRules,
                    presentationType: .login(
                        .value(
                            (
                                login.username,
                                login.password
                            )
                        )
                    )
                )
            }
        }
            .padding(.leading, 16)
            .padding(.vertical, 12)
    }
    
    private var loginButton: some View {
        let loginButtonDisabled = state == .processing || !valid
        let loginButtonTitleLocalization: String
        switch localization {
        case .environment:
            loginButtonTitleLocalization = usernamePasswordLoginService.localization.login.loginActionButtonTitle
        case let .value(login):
            loginButtonTitleLocalization = login.loginActionButtonTitle
        }
        
        return Button(action: loginButtonPressed) {
            Text(loginButtonTitleLocalization)
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
            .disabled(loginButtonDisabled)
            .padding()
    }
    
    private var navigationTitle: String {
        switch localization {
        case .environment:
            return usernamePasswordLoginService.localization.login.navigationTitle
        case let .value(login):
            return login.navigationTitle
        }
    }
    
    
    init<Header: View, Footer: View>(
        usernameValidationRules: [ValidationRule] = [],
        passwordValidationRules: [ValidationRule] = [],
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder footer: () -> Footer = { EmptyView() },
        localization: ConfigurableLocalization<Localization.Login> = .environment
    ) {
        self.usernameValidationRules = usernameValidationRules
        self.passwordValidationRules = passwordValidationRules
        self.header = AnyView(header())
        self.footer = AnyView(footer())
        self.localization = localization
    }
    
    
    private func loginButtonPressed() {
        guard !(state == .processing) else {
            return
        }
        
        withAnimation(.easeOut(duration: 0.2)) {
            focusedField = .none
            state = .processing
        }
        
        Task {
            do {
                try await usernamePasswordLoginService.login(username: username, password: password)
                withAnimation(.easeIn(duration: 0.2)) {
                    state = .idle
                }
            } catch {
                state = .error(error)
            }
        }
    }
}


struct UsernamePasswordLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UsernamePasswordLoginView()
                .environmentObject(UsernamePasswordAccountService())
        }
    }
}
