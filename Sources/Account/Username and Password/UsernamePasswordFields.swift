//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct UsernamePasswordFields: View {
    enum PresentationType: Hashable {
        case login
        case signUp
    }
    
    
    private let localization: Localization
    private let usernameValidationRules: [ValidationRule]
    private let passwordValidationRules: [ValidationRule]
    private let presentationType: PresentationType
    
    @FocusState var focusedField: LoginAndSignUpFields?
    
    @EnvironmentObject private var usernamePasswordLoginService: UsernamePasswordLoginService
    
    @Binding private var valid: Bool
    @Binding private var username: String
    @Binding private var password: String
    
    @State private var passwordRepeat: String = ""
    
    @State private var usernameValid: Bool = false
    @State private var passwordValid: Bool = false
    @State private var passwordRepeatValid: Bool = false
    
    
    var body: some View {
        Group {
            VerifyableTextFieldGridRow(
                text: $username,
                valid: $usernameValid,
                validationRules: usernameValidationRules
            ) {
                Text(localization.usernameTitle)
            } textField: { binding in
                TextField(text: binding) {
                    Text(localization.usernamePlaceholder)
                }
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textContentType(.username)
            }
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .username)
            Divider()
            VerifyableTextFieldGridRow(
                text: $password,
                valid: $passwordValid,
                validationRules: passwordValidationRules
            ) {
                Text(localization.passwordTitle)
            } textField: { binding in
                SecureField(text: binding) {
                    Text(localization.passwordPlaceholder)
                }
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(presentationType == .login ? .password : .newPassword)
            }
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .password)
            if presentationType == .signUp {
                Divider()
                VerifyableTextFieldGridRow(
                    text: $passwordRepeat,
                    valid: $passwordRepeatValid,
                    validationRules: passwordValidationRules
                ) {
                    Text(localization.passwordRepeatTitle)
                } textField: { binding in
                    VStack {
                        SecureField(text: binding) {
                            Text(localization.passwordRepeatPlaceholder)
                        }
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textContentType(.newPassword)
                        if password != passwordRepeat && !passwordRepeat.isEmpty {
                            HStack {
                                Text(localization.passwordRepeatNotEqual)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .gridColumnAlignment(.leading)
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                Spacer(minLength: 0)
                            }
                        }
                    }
                }
                    .onTapFocus(focusedField: _focusedField, fieldIdentifier: .passwordRepeat)
            }
        }
            .onChange(of: usernameValid) { _ in
                updateValid()
            }
            .onChange(of: passwordValid) { _ in
                updateValid()
            }
    }
    
    
    init(
        username: Binding<String>,
        password: Binding<String>,
        valid: Binding<Bool>,
        focusState: FocusState<LoginAndSignUpFields?> = FocusState<LoginAndSignUpFields?>(),
        localization: Localization = .default,
        usernameValidationRules: [ValidationRule] = [],
        passwordValidationRules: [ValidationRule] = [],
        presentationType: PresentationType = .login
    ) {
        self._username = username
        self._password = password
        self._valid = valid
        self._focusedField = focusState
        self.localization = localization
        self.usernameValidationRules = usernameValidationRules
        self.passwordValidationRules = passwordValidationRules
        self.presentationType = presentationType
    }
    
    
    private func updateValid() {
        switch presentationType {
        case .login:
            valid = usernameValid && passwordValid
        case .signUp:
            valid = usernameValid
                && passwordValid
                && passwordRepeatValid
                && password == passwordRepeat
        }
    }
}



struct UsernamePasswordFields_Previews: PreviewProvider {
    @State private static var username: String = ""
    @State private static var password: String = ""
    @State private static var valid: Bool = false
    
    
    private static var validationRules: [ValidationRule] {
        guard let regex = try? Regex("[a-zA-Z]") else {
            return []
        }
        
        return [
            ValidationRule(
                regex: regex,
                message: "Validation failed: Required only letters."
            )
        ]
    }
    
    static var previews: some View {
        Form {
            Section {
                Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                    UsernamePasswordFields(
                        username: $username,
                        password: $password,
                        valid: $valid,
                        usernameValidationRules: validationRules,
                        passwordValidationRules: validationRules
                    )
                }
            }
            Section {
                Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                    UsernamePasswordFields(
                        username: $username,
                        password: $password,
                        valid: $valid,
                        usernameValidationRules: validationRules,
                        passwordValidationRules: validationRules,
                        presentationType: .signUp
                    )
                }
            }
        }
    }
}
