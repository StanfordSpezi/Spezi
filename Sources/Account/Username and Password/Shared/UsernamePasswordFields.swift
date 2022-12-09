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
        
        
        var username: Localization.Field? {
            switch self {
            case let .login(.value((username, _))):
                return username
            default:
                return nil
            }
        }
        
        var password: Localization.Field? {
            switch self {
            case let .login(.value((_, password))):
                return password
            default:
                return nil
            }
        }
    }
    
    
    private let usernameValidationRules: [ValidationRule]
    private let passwordValidationRules: [ValidationRule]
    private let presentationType: PresentationType
    
    @FocusState var focusedField: AccountInputFields?
    
    @EnvironmentObject private var usernamePasswordLoginService: UsernamePasswordAccountService
    
    @Binding private var valid: Bool
    @Binding private var username: String
    @Binding private var password: String
    
    @State private var passwordRepeat: String = ""
    
    @State private var usernameValid = false
    @State private var passwordValid = false
    @State private var passwordRepeatValid = false
    
    
    var body: some View {
        Group {
            usernameTextField
            Divider()
            passwordSecureField
        }
            .onChange(of: usernameValid) { _ in
                updateValid()
            }
            .onChange(of: passwordValid) { _ in
                updateValid()
            }
            .onChange(of: passwordRepeatValid) { _ in
                updateValid()
            }
            .onChange(of: password) { _ in
                updateValid()
            }
            .onChange(of: passwordRepeat) { _ in
                updateValid()
            }
    }
    
    private var usernameTextField: some View {
        let usernameLocalization: Localization.Field
        if let username = presentationType.username {
            usernameLocalization = username
        } else {
            switch presentationType {
            case .login:
                usernameLocalization = usernamePasswordLoginService.localization.login.username
            }
        }
        
        return VerifyableTextFieldGridRow(
            text: $username,
            valid: $usernameValid,
            validationRules: usernameValidationRules,
            description: {
                Text(usernameLocalization.title)
            },
            textField: { binding in
                TextField(text: binding) {
                    Text(usernameLocalization.placeholder)
                }
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textContentType(.username)
            }
        )
            .onTapFocus(focusedField: _focusedField, fieldIdentifier: .username)
    }
    
    private var passwordSecureField: some View {
        let passwordLocalization: Localization.Field
        if let password = presentationType.password {
            passwordLocalization = password
        } else {
            switch presentationType {
            case .login:
                passwordLocalization = usernamePasswordLoginService.localization.login.password
            }
        }
        
        return VerifyableTextFieldGridRow(
            text: $password,
            valid: $passwordValid,
            validationRules: passwordValidationRules,
            description: {
                Text(passwordLocalization.title)
            },
            textField: { binding in
                SecureField(text: binding) {
                    Text(passwordLocalization.placeholder)
                }
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(.password)
            }
        )
            .onTapFocus(focusedField: _focusedField, fieldIdentifier: .password)
    }
    
    
    init(
        username: Binding<String>,
        password: Binding<String>,
        valid: Binding<Bool>,
        focusState: FocusState<AccountInputFields?> = FocusState<AccountInputFields?>(),
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
        valid = usernameValid && passwordValid
    }
}


struct UsernamePasswordFields_Previews: PreviewProvider {
    @State private static var username: String = ""
    @State private static var password: String = ""
    @State private static var valid = false
    
    
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
        }
            .environmentObject(UsernamePasswordAccountService())
    }
}
