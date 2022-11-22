//
//  SwiftUIView.swift
//  
//
//  Created by Paul Shmiedmayer on 11/21/22.
//

import SwiftUI


struct VerifyableTextGridRow<FocusedField: Hashable>: View {
    private let title: String
    private let placeholder: String
    private let fieldIdentifier: FocusedField
    private let validationRules: [ValidationRule]
    
    
    @Binding private var text: String
    @FocusState private var focusedField: FocusedField?
    @Binding private var valid: Bool
    
    @State private var validationResults: [String] = []
    
    
    var body: some View {
        DescriptionGridRow {
            Text(title)
        } content: {
            VStack(spacing: 0) {
                TextField(placeholder, text: $text)
                    .focused($focusedField, equals: fieldIdentifier)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .frame(maxWidth: .infinity)
                    .onSubmit {
                        validation()
                    }
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(validationResults, id: \.self) { message in
                            Text(message)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                        .gridColumnAlignment(.leading)
                        .font(.footnote)
                        .foregroundColor(.red)
                    Spacer(minLength: 0)
                }
            }
        }
            .onTapGesture {
                focusedField = fieldIdentifier
            }
            .onChange(of: focusedField) { _ in
                validation()
            }
        
    }
    
    
    init(
        text: Binding<String>,
        focusedField: FocusState<FocusedField?>,
        valid: Binding<Bool>,
        title: String,
        placeholder: String,
        fieldIdentifier: FocusedField,
        validationRules: [ValidationRule] = []
    ) {
        self._text = text
        self._focusedField = focusedField
        self._valid = valid
        self.title = title
        self.placeholder = placeholder
        self.fieldIdentifier = fieldIdentifier
        self.validationRules = validationRules
    }
    
    init(
        text: Binding<String>,
        valid: Binding<Bool>,
        title: String,
        placeholder: String,
        validationRules: [ValidationRule] = []
    ) where FocusedField == UUID {
        self._text = text
        self._focusedField = FocusState<FocusedField?>()
        self._valid = valid
        self.title = title
        self.placeholder = placeholder
        self.fieldIdentifier = UUID()
        self.validationRules = validationRules
    }
    
    
    private func validation() {
        withAnimation(.easeInOut(duration: 0.2)) {
            defer {
                updateValid()
            }
            
            guard !text.isEmpty else {
                validationResults = []
                return
            }
            
            validationResults = validationRules.compactMap { $0.validate(text) }
        }
    }
    
    private func updateValid() {
        valid = text.isEmpty || !validationResults.isEmpty
    }
}

struct VerifyableTextFieldTextFieldGridRow<FocusedField: Hashable, Description: View, TextField: View>: View {
    private let description: Description
    private let textField: TextField
    private let fieldIdentifier: FocusedField
    private let validationRules: [ValidationRule]
    
    @Binding private var text: String
    @FocusState private var focusedField: FocusedField?
    @Binding private var valid: Bool
    
    @State private var validationResults: [String] = []
    
    
    var body: some View {
        DescriptionGridRow {
            description
                .fixedSize(horizontal: false, vertical: true)
        } content: {
            VStack {
                textField
                    .focused($focusedField, equals: fieldIdentifier)
                    .frame(maxWidth: .infinity)
                    .onSubmit {
                        validation()
                    }
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(validationResults, id: \.self) { message in
                            Text(message)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                        .gridColumnAlignment(.leading)
                        .font(.footnote)
                        .foregroundColor(.red)
                    Spacer(minLength: 0)
                }
            }
        }
            .onTapGesture {
                focusedField = fieldIdentifier
            }
            .onChange(of: focusedField) { _ in
                validation()
            }
        
    }
    
    
    init(
        text: Binding<String>,
        focusedField: FocusState<FocusedField?>,
        valid: Binding<Bool>,
        fieldIdentifier: FocusedField,
        validationRules: [ValidationRule] = [],
        @ViewBuilder description: () -> Description,
        @ViewBuilder textField: (Binding<String>) -> TextField
    ) {
        self._text = text
        self._focusedField = focusedField
        self._valid = valid
        self.fieldIdentifier = fieldIdentifier
        self.validationRules = validationRules
        self.description = description()
        self.textField = textField(text)
    }
    
    init(
        text: Binding<String>,
        valid: Binding<Bool>,
        validationRules: [ValidationRule] = [],
        @ViewBuilder description: () -> Description,
        @ViewBuilder textField: (Binding<String>) -> TextField
    ) where FocusedField == UUID {
        self.init(
            text: text,
            focusedField: FocusState<FocusedField?>(),
            valid: valid,
            fieldIdentifier: UUID(),
            description: description,
            textField: textField
        )
    }
    
    init(
        text: Binding<String>,
        valid: Binding<Bool>,
        validationRules: [ValidationRule] = [],
        description: String,
        @ViewBuilder textField: (Binding<String>) -> TextField
    ) where FocusedField == UUID, Description == Text {
        self.init(
            text: text,
            focusedField: FocusState<FocusedField?>(),
            valid: valid,
            fieldIdentifier: UUID(),
            description: { Text(description) },
            textField: textField
        )
    }
    
    
    private func validation() {
        withAnimation(.easeInOut(duration: 0.2)) {
            defer {
                updateValid()
            }
            
            guard !text.isEmpty else {
                validationResults = []
                return
            }
            
            validationResults = validationRules.compactMap { $0.validate(text) }
        }
    }
    
    private func updateValid() {
        valid = text.isEmpty || !validationResults.isEmpty
    }
}

struct DescriptionGridRow<Description: View, Content: View>: View {
    private let description: Description
    private let content: Content
    
    
    var body: some View {
        GridRow {
            description
                .fontWeight(.semibold)
                .gridColumnAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            content
                .frame(maxWidth: .infinity)
        }
            .contentShape(Rectangle())
    }
    
    
    init(
        @ViewBuilder description: () -> Description,
        @ViewBuilder content: () -> Content
    ) {
        self.description = description()
        self.content = content()
    }
}


struct VerifyableTextGridRow_Previews: PreviewProvider {
    private enum Field: Hashable {
        case first
        case second
    }
    
    
    @State private static var text: String = ""
    @State private static var valid: Bool = false
    @FocusState private static var focusedField: Field?
    
    
    static var previews: some View {
        VStack {
            Form {
                Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                    VerifyableTextFieldTextFieldGridRow(
                        text: $text,
                        valid: $valid
                    ) {
                        Text("Text")
                    } textField: { binding in
                        TextField(text: binding) {
                            Text("Placeholder ...")
                        }
                    }
                    Divider()
                    VerifyableTextFieldTextFieldGridRow(
                        text: $text,
                        valid: $valid,
                        description: "Secure Text"
                    ) { binding in
                        SecureField(text: binding) {
                            Text("Secure Placeholder ...")
                        }
                    }
                }
            }
            Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                VerifyableTextFieldTextFieldGridRow(
                    text: $text,
                    focusedField: _focusedField,
                    valid: $valid,
                    fieldIdentifier: .first
                ) {
                    Text("Text")
                } textField: { binding in
                    TextField(text: binding) {
                        Text("Placeholder ...")
                    }
                }
                Divider()
                VerifyableTextFieldTextFieldGridRow(
                    text: $text,
                    focusedField: _focusedField,
                    valid: $valid,
                    fieldIdentifier: .second
                ) {
                    Text("Text")
                } textField: { binding in
                    SecureField(text: binding) {
                        Text("Secure Placeholder ...")
                    }
                }
            }
                .padding(32)
        }
            .background(Color(.systemGroupedBackground))
    }
}
