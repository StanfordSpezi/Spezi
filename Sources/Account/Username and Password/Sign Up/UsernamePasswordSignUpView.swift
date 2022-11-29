//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct UsernamePasswordSignUpView: View {
    enum Constants {
        static let formVerticalPadding: CGFloat = 8
    }
    
    
    private let usernameValidationRules: [ValidationRule]
    private let passwordValidationRules: [ValidationRule]
    private let header: AnyView
    private let footer: AnyView
    private let signUpOptions: SignUpOptions
    
    @EnvironmentObject private var usernamePasswordLoginService: UsernamePasswordLoginService
    
    @State private var username = ""
    @State private var password = ""
    @State private var name = PersonNameComponents()
    @State private var dateOfBirth = Date()
    @State private var genderIdentity: GenderIdentity = .preferNotToState
    @State private var state: AccountViewState = .idle
    
    @State private var usernamePasswordValid: Bool = false
    @FocusState private var focusedField: LoginAndSignUpFields?
    
    private let localization: ConfigurableLocalization<Localization.SignUp>
    
    
    var body: some View {
        Form {
            header
            if signUpOptions.contains(.usernameAndPassword) {
                Section {
                    Grid(alignment: .leading) {
                        switch localization {
                        case .environment:
                            UsernamePasswordFields(
                                username: $username,
                                password: $password,
                                valid: $usernamePasswordValid,
                                focusState: _focusedField,
                                usernameValidationRules: usernameValidationRules,
                                passwordValidationRules: passwordValidationRules,
                                presentationType: .signUp(.environment)
                            )
                        case let .value(signUp):
                            UsernamePasswordFields(
                                username: $username,
                                password: $password,
                                valid: $usernamePasswordValid,
                                focusState: _focusedField,
                                usernameValidationRules: usernameValidationRules,
                                passwordValidationRules: passwordValidationRules,
                                presentationType: .signUp(
                                    .value(
                                        (
                                            signUp.username,
                                            signUp.password,
                                            signUp.passwordRepeat,
                                            signUp.passwordNotEqualError
                                        )
                                    )
                                )
                            )
                        }
                    }
                } header: {
                    Text("SU_USERNAME_AND_PASSWORD_SECTION", bundle: .module)
                }
            }
            if signUpOptions.contains(.name) {
                Section {
                    NameTextFields(name: $name, focusState: _focusedField)
                } header: {
                    Text("SU_NAME_SECTION", bundle: .module)
                }
            }
            if signUpOptions.contains(.dateOfBirth) {
                Section {
                    DateOfBirthPicker(date: $dateOfBirth)
                } header: {
                    Text("SU_DATE_OF_BIRTH_SECTION", bundle: .module)
                }
            }
            if signUpOptions.contains(.genderIdentity) {
                Section {
                    GenderIdentityPicker(genderIdentity: $genderIdentity)
                } header: {
                    Text("SU_GENDER_IDENTIFY_SECTION", bundle: .module)
                }
            }
            Button(action: signUpButtonPressed) {
                Text("SU_BUTTON_TITLE")
                    .padding(6)
                    .frame(maxWidth: .infinity)
                    .opacity(state == .processing ? 0.0 : 1.0)
                    .overlay {
                        if state == .processing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
            }
                .buttonStyle(.borderedProminent)
                .disabled(signUpButtonDisabled)
                .padding()
                .padding(-34)
                .listRowBackground(Color.clear)
            footer
        }
            .navigationTitle("SU_NAVIGATION_TITLE")
    }
    
    
    private var signUpButtonDisabled: Bool {
        state == .processing || !usernamePasswordValid
    }
    
    
    init<Header: View, Footer: View>(
        signUpOptions: SignUpOptions = .default,
        usernameValidationRules: [ValidationRule] = [],
        passwordValidationRules: [ValidationRule] = [],
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder footer: () -> Footer = { EmptyView() },
        localization: ConfigurableLocalization<Localization.SignUp> = .environment
    ) {
        self.signUpOptions = signUpOptions
        self.usernameValidationRules = usernameValidationRules
        self.passwordValidationRules = passwordValidationRules
        self.header = AnyView(header())
        self.footer = AnyView(footer())
        self.localization = localization
    }
    
    
    private func signUpButtonPressed() {
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


struct UsernamePasswordSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UsernamePasswordSignUpView()
                .environmentObject(UsernamePasswordLoginService(account: Account()))
        }
    }
}
