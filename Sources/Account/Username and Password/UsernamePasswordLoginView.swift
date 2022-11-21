//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


private enum UsernamePasswordLoginViewState: Equatable {
    case idle
    case processing
    case error(Error)
    
    
    var errorTitle: String {
        switch self {
        case let .error(error as LocalizedError):
            return error.errorDescription
                ?? String(localized: "LOGIN_UAP_DEFAULT_ERROR", bundle: .module)
        default:
            return String(localized: "LOGIN_UAP_DEFAULT_ERROR", bundle: .module)
        }
    }
    
    var errorDescription: String {
        switch self {
        case let .error(error as LocalizedError):
            var errorDescription = ""
            if let failureReason = error.failureReason {
                errorDescription.append("\(failureReason)\n\n")
            }
            if let helpAnchor = error.helpAnchor {
                errorDescription.append("\(helpAnchor)\n\n")
            }
            if let recoverySuggestion = error.recoverySuggestion {
                errorDescription.append("\(recoverySuggestion)\n\n")
            }
            if errorDescription.isEmpty {
                errorDescription = error.localizedDescription
            }
            return errorDescription
        case let .error(error):
            return error.localizedDescription
        default:
            return ""
        }
    }
    
    static func == (lhs: UsernamePasswordLoginViewState, rhs: UsernamePasswordLoginViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.processing, .processing), (.error, .error):
            return true
        default:
            return false
        }
    }
}


struct UsernamePasswordLoginView<Header: View, Footer: View>: View {
    enum Field: Hashable {
        case username
        case password
    }
    
    
    private let viewLocalization: UsernamePasswordLoginViewLocalization
    private let usernameValidationRules: [ValidationRule]
    private let passwordValidationRules: [ValidationRule]
    private let header: Header
    private let footer: Footer
    
    @EnvironmentObject private var usernamePasswordLoginService: UsernamePasswordLoginService
    
    @State private var username: String = ""
    @State private var usernameValidationResults: [String] = []
    @State private var password: String = ""
    @State private var passwordValidationResults: [String] = []
    @FocusState private var focusedField: Field?
    @State private var state: UsernamePasswordLoginViewState = .idle
    
    
    var body: some View {
        ScrollView {
            header
            Divider()
            Grid(horizontalSpacing: 16, verticalSpacing: 0) {
                GridRow {
                    Text(viewLocalization.usernameTitle)
                        .fontWeight(.semibold)
                        .gridColumnAlignment(.leading)
                    TextField(viewLocalization.usernamePlaceholder, text: $username)
                        .frame(maxWidth: .infinity)
                        .focused($focusedField, equals: .username)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit {
                            usernameValidation()
                        } 
                }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        focusedField = .username
                    }
                    .padding(.vertical, 8)
                GridRow {
                    Spacer(minLength: 0)
                    HStack() {
                        ForEach(usernameValidationResults, id: \.self) { message in
                            Text(message)
                        }
                    }
                        .gridColumnAlignment(.leading)
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                Divider()
                    .padding(.vertical, 10)
                GridRow {
                    Text(viewLocalization.passwordTitle)
                        .fontWeight(.semibold)
                        .gridColumnAlignment(.leading)
                    SecureField(viewLocalization.passwordPlaceholder, text: $password)
                        .frame(maxWidth: .infinity)
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            passwordValidation()
                        }
                }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        focusedField = .password
                    }
                    .padding(.vertical, 10)
                    .padding(.bottom, -0.1)
                GridRow {
                    Spacer(minLength: 0)
                    HStack() {
                        ForEach(passwordValidationResults, id: \.self) { message in
                            Text(message)
                        }
                    }
                        .gridColumnAlignment(.leading)
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
                .padding(.leading, 16)
            Divider()
                .padding(.top, 10)
            Button(action: loginButtonPressed) {
                Text(viewLocalization.loginButtonTitle)
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
            .navigationTitle(viewLocalization.navigationTitle)
            .navigationBarBackButtonHidden(state == .processing)
            .alert(state.errorTitle, isPresented: errorAlertBinding) {
                Text(state.errorDescription)
            }
            .onTapGesture {
                focusedField = nil
            }
            .onChange(of: focusedField) { _ in
                usernameValidation()
                passwordValidation()
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
        state == .processing
            || username.isEmpty
            || password.isEmpty
            || !usernameValidationResults.isEmpty
            || !passwordValidationResults.isEmpty
    }
    
    
    init(
        viewLocalization: UsernamePasswordLoginViewLocalization = .default,
        usernameValidationRules: [ValidationRule] = [],
        passwordValidationRules: [ValidationRule] = [],
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.viewLocalization = viewLocalization
        self.usernameValidationRules = usernameValidationRules
        self.passwordValidationRules = passwordValidationRules
        self.header = header()
        self.footer = footer()
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
    
    private func usernameValidation() {
        withAnimation(.easeInOut(duration: 0.2)) {
            guard !username.isEmpty else {
                usernameValidationResults = []
                return
            }
            
            usernameValidationResults = usernameValidationRules.compactMap { $0.validate(username) }
        }
    }
    
    private func passwordValidation() {
        withAnimation(.easeInOut(duration: 0.2)) {
            guard !password.isEmpty else {
                passwordValidationResults = []
                return
            }
            
            passwordValidationResults = passwordValidationRules.compactMap { $0.validate(password) }
        }
    }
}


struct UsernamePasswordLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UsernamePasswordLoginView()
                .environmentObject(UsernamePasswordLoginService(account: Account()))
        }
    }
}
