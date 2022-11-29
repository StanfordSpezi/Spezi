//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct UsernamePasswordFields: View {
    enum PresentationType {
        case login(ConfigurableLocalization<(
            username: Localization.Field,
            password: Localization.Field
        )>)
        case signUp(ConfigurableLocalization<(
            username: Localization.Field,
            password: Localization.Field,
            passwordRepeat: Localization.Field,
            passwordNotEqualError: String
        )>)
        
        
        var login: Bool {
            if case .login(_) = self {
                return true
            } else {
                return false
            }
        }
        
        var signUp: Bool {
            if case .signUp(_) = self {
                return true
            } else {
                return false
            }
        }
        
        
        var username: Localization.Field? {
            switch self {
            case let .login(.value((username, _))), let .signUp(.value((username, _, _, _))):
                return username
            default:
                return nil
            }
        }
        
        var password: Localization.Field? {
            switch self {
            case let .login(.value((_, password))), let .signUp(.value((_, password, _, _))):
                return password
            default:
                return nil
            }
        }
        
        var passwordRepeat: Localization.Field? {
            switch self {
            case let .signUp(.value((_, _, passwordRepeat, _))):
                return passwordRepeat
            default:
                return nil
            }
        }
        
        var passwordNotEqualError: String? {
            switch self {
            case let .signUp(.value((_, _, _, passwordNotEqualError))):
                return passwordNotEqualError
            default:
                return nil
            }
        }
    }
    
    
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
    
    
    private var usernameField: Localization.Field {
        if let usernameField = presentationType.username {
            return usernameField
        } else {
            switch presentationType {
            case .login:
                return usernamePasswordLoginService.localization.login.username
            case .signUp:
                return usernamePasswordLoginService.localization.signUp.username
            }
        }
    }
    
    private var passwordField: Localization.Field {
        if let passwordField = presentationType.password {
            return passwordField
        } else {
            switch presentationType {
            case .login:
                return usernamePasswordLoginService.localization.login.password
            case .signUp:
                return usernamePasswordLoginService.localization.signUp.password
            }
        }
    }
    
    
    private var passwordRepeatField: Localization.Field {
        if let passwordRepeatField = presentationType.passwordRepeat {
            return passwordRepeatField
        } else {
            switch presentationType {
            case .login:
                preconditionFailure("The password repeat field should never be shown in the login presentation type.")
            case .signUp:
                return usernamePasswordLoginService.localization.signUp.passwordRepeat
            }
        }
    }
    
    private var passwordNotEqualError: String {
        if let passwordNotEqualError = presentationType.passwordNotEqualError {
            return passwordNotEqualError
        } else {
            switch presentationType {
            case .login:
                preconditionFailure("The password not equal error should never be shown in the login presentation type.")
            case .signUp:
                return usernamePasswordLoginService.localization.signUp.passwordNotEqualError
            }
        }
    }
    
    
    var body: some View {
        Group {
            VerifyableTextFieldGridRow(
                text: $username,
                valid: $usernameValid,
                validationRules: usernameValidationRules
            ) {
                Text(usernameField.title)
            } textField: { binding in
                TextField(text: binding) {
                    Text(usernameField.placeholder)
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
                Text(passwordField.title)
            } textField: { binding in
                SecureField(text: binding) {
                    Text(passwordField.placeholder)
                }
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(presentationType.login ? .password : .newPassword)
            }
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .password)
            if presentationType.signUp {
                Divider()
                VerifyableTextFieldGridRow(
                    text: $passwordRepeat,
                    valid: $passwordRepeatValid,
                    validationRules: passwordValidationRules
                ) {
                    Text(passwordRepeatField.title)
                } textField: { binding in
                    VStack {
                        SecureField(text: binding) {
                            Text(passwordRepeatField.placeholder)
                        }
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textContentType(.newPassword)
                        if password != passwordRepeat && !passwordRepeat.isEmpty {
                            HStack {
                                Text(passwordNotEqualError)
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
        usernameValidationRules: [ValidationRule] = [],
        passwordValidationRules: [ValidationRule] = [],
        presentationType: PresentationType = .login(.environment)
    ) {
        self._username = username
        self._password = password
        self._valid = valid
        self._focusedField = focusState
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
                        presentationType: .signUp(.environment)
                    )
                }
            }
        }
            .environmentObject(UsernamePasswordLoginService(account: Account()))
    }
}
