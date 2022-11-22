//
//  SwiftUIView.swift
//  
//
//  Created by Paul Shmiedmayer on 11/21/22.
//

import SwiftUI


struct UsernamePasswordFields: View {
    public struct Localization {
        public let usernameTitle: String
        public let passwordTitle: String
        public let usernamePlaceholder: String
        public let passwordPlaceholder: String
        
        
        public static let `default` = Localization(
            usernameTitle: String(localized: "LOGIN_UAP_USERNAME_TITLE", bundle: .module),
            passwordTitle: String(localized: "LOGIN_UAP_PASSWORD_TITLE", bundle: .module),
            usernamePlaceholder: String(localized: "LOGIN_UAP_USERNAME_PLACEHOLDER", bundle: .module),
            passwordPlaceholder: String(localized: "LOGIN_UAP_PASSWORD_PLACEHOLDER", bundle: .module)
        )
        
        
        public init(
            usernameTitle: String = `default`.usernameTitle,
            passwordTitle: String = `default`.passwordTitle,
            usernamePlaceholder: String = `default`.usernamePlaceholder,
            passwordPlaceholder: String = `default`.passwordPlaceholder
        ) {
            self.usernameTitle = usernameTitle
            self.passwordTitle = passwordTitle
            self.usernamePlaceholder = usernamePlaceholder
            self.passwordPlaceholder = passwordPlaceholder
        }
    }
    
    enum PresentationType: Hashable {
        case login
        case signUp
    }
    
    
    private let viewLocalization: UsernamePasswordLoginViewLocalization
    private let usernameValidationRules: [ValidationRule]
    private let passwordValidationRules: [ValidationRule]
    private let presentationType: PresentationType
    
    @FocusState var focusedField: LoginAndSignUpFields?
    
    @EnvironmentObject private var usernamePasswordLoginService: UsernamePasswordLoginService
    
    @Binding private var valid: Bool
    @Binding private var username: String
    @Binding private var password: String
    
    @State private var usernameValid: Bool = false
    @State private var passwordValid: Bool = false
    
    
    var body: some View {
        Group {
            VerifyableTextFieldGridRow(
                text: $username,
                valid: $usernameValid,
                validationRules: usernameValidationRules
            ) {
                Text(viewLocalization.usernameTitle)
            } textField: { binding in
                TextField(text: binding) {
                    Text(viewLocalization.usernamePlaceholder)
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
                Text(viewLocalization.passwordTitle)
            } textField: { binding in
                TextField(text: binding) {
                    Text(viewLocalization.passwordPlaceholder)
                }
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(.password)
            }
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .password)
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
        viewLocalization: UsernamePasswordLoginViewLocalization = .default,
        usernameValidationRules: [ValidationRule] = [],
        passwordValidationRules: [ValidationRule] = [],
        presentationType: PresentationType = .login
    ) {
        self._username = username
        self._password = password
        self._valid = valid
        self._focusedField = focusState
        self.viewLocalization = viewLocalization
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
}
