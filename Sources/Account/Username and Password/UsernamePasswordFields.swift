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
    
    enum Field: Hashable {
        case username
        case password
    }
    
    enum PresentationType: Hashable {
        case login
        case signUp
    }
    
    
    private let viewLocalization: UsernamePasswordLoginViewLocalization
    private let usernameValidationRules: [ValidationRule]
    private let passwordValidationRules: [ValidationRule]
    private let presentationType: PresentationType
    
    @FocusState var focusedField: Field?
    
    @EnvironmentObject private var usernamePasswordLoginService: UsernamePasswordLoginService
    
    @Binding private var valid: Bool
    @Binding private var username: String
    @Binding private var password: String
    
    @State private var usernameValidationResults: [String] = []
    @State private var passwordValidationResults: [String] = []
    
    
    var body: some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 0) {
            GridRow {
                Text(viewLocalization.usernameTitle)
                    .fontWeight(.semibold)
                    .gridColumnAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
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
                .padding(.top, 8)
            GridRow {
                Spacer(minLength: 0)
                VStack {
                    ForEach(usernameValidationResults, id: \.self) { message in
                        Text(message)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                    .gridColumnAlignment(.leading)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            Divider()
                .gridCellUnsizedAxes(.horizontal)
                .padding(.bottom, 5)
            GridRow {
                Text(viewLocalization.passwordTitle)
                    .fontWeight(.semibold)
                    .gridColumnAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
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
                .padding(.top, 4)
            GridRow {
                Spacer(minLength: 0)
                VStack {
                    ForEach(passwordValidationResults, id: \.self) { message in
                        Text(message)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                    .gridColumnAlignment(.leading)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        }
            .onChange(of: focusedField) { _ in
                usernameValidation()
                passwordValidation()
            }
    }
    
    
    init(
        username: Binding<String>,
        password: Binding<String>,
        valid: Binding<Bool>,
        viewLocalization: UsernamePasswordLoginViewLocalization = .default,
        usernameValidationRules: [ValidationRule] = [],
        passwordValidationRules: [ValidationRule] = [],
        presentationType: PresentationType = .login
    ) {
        self._username = username
        self._password = password
        self._valid = valid
        self.viewLocalization = viewLocalization
        self.usernameValidationRules = usernameValidationRules
        self.passwordValidationRules = passwordValidationRules
        self.presentationType = presentationType
    }
    
    
    private func usernameValidation() {
        withAnimation(.easeInOut(duration: 0.2)) {
            defer {
                updateValid()
            }
            
            guard !username.isEmpty else {
                usernameValidationResults = []
                return
            }
            
            usernameValidationResults = usernameValidationRules.compactMap { $0.validate(username) }
        }
    }
    
    private func passwordValidation() {
        withAnimation(.easeInOut(duration: 0.2)) {
            defer {
                updateValid()
            }
            
            guard !password.isEmpty else {
                passwordValidationResults = []
                return
            }
            
            passwordValidationResults = passwordValidationRules.compactMap { $0.validate(password) }
        }
    }
    
    private func updateValid() {
        valid = username.isEmpty
            || password.isEmpty
            || !usernameValidationResults.isEmpty
            || !passwordValidationResults.isEmpty
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
