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
    @State private var valid: Bool = false
    @FocusState private var focusedField: LoginAndSignUpFields?
    @State private var state: AccountViewState = .idle
    
    private let localization: ConfigurableLocalization<Localization.Login>
    
    
    private var loginButtonTitle: String {
        switch localization {
        case .environment:
            return usernamePasswordLoginService.localization.login.buttonTitle
        case let .value(login):
            return login.buttonTitle
        }
    }
    
    private var navigationTitle: String {
        switch localization {
        case .environment:
            return usernamePasswordLoginService.localization.login.navigationTitle
        case let .value(login):
            return login.navigationTitle
        }
    }
    
    var body: some View {
        ScrollView {
            header
            Divider()
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
            Divider()
            Button(action: loginButtonPressed) {
                Text(loginButtonTitle)
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
            footer
        }
            .navigationTitle(navigationTitle)
            .navigationBarBackButtonHidden(state == .processing)
            .alert(state.errorTitle, isPresented: errorAlertBinding) {
                Text(state.errorDescription)
            }
            .onTapGesture {
                focusedField = nil
            }
    }
    
    private var errorAlertBinding: Binding<Bool> {
        Binding {
            if case .error = state {
                return true
            } else {
                return false
            }
        } set: { newValue in
            state = .idle
        }
    }
    
    private var loginButtonDisabled: Bool {
        state == .processing || !valid
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
            } catch {
                state = .error(error)
            }
            withAnimation(.easeIn(duration: 0.2)) {
                state = .idle
            }
        }
    }
}


struct UsernamePasswordLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UsernamePasswordLoginView()
                .environmentObject(UsernamePasswordAccountService(account: Account()))
        }
    }
}
