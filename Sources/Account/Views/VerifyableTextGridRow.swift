//
//  SwiftUIView.swift
//  
//
//  Created by Paul Shmiedmayer on 11/21/22.
//

import SwiftUI


struct VerifyableTextFieldGridRow<Description: View, TextField: View>: View {
    private let description: Description
    private let textField: TextField
    private let validationRules: [ValidationRule]
    
    @Binding private var text: String
    @Binding private var valid: Bool
    
    @State private var debounceTask: Task<Void, Never>? {
        willSet {
            self.debounceTask?.cancel()
        }
    }
    @State private var validationResults: [String] = []
    
    
    var body: some View {
        DescriptionGridRow {
            description
        } content: {
            VStack {
                textField
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
            .onChange(of: text) { _ in
                validation()
            }
            .onTapFocus()
    }
    
    
    init(
        text: Binding<String>,
        valid: Binding<Bool>,
        validationRules: [ValidationRule] = [],
        @ViewBuilder description: () -> Description,
        @ViewBuilder textField: (Binding<String>) -> TextField
    ) {
        self._text = text
        self._valid = valid
        self.validationRules = validationRules
        self.description = description()
        self.textField = textField(text)
    }
    
    init(
        text: Binding<String>,
        valid: Binding<Bool>,
        validationRules: [ValidationRule] = [],
        description: String,
        @ViewBuilder textField: (Binding<String>) -> TextField
    ) where Description == Text {
        self.init(
            text: text,
            valid: valid,
            description: { Text(description) },
            textField: textField
        )
    }
    
    
    private func validation() {
        debounceTask = Task {
            // Wait 0.5 seconds until you start the validation.
            try? await Task.sleep(for: .seconds(0.5))
            
            guard !Task.isCancelled else {
                return
            }
            
            SwiftUI.withAnimation(.easeInOut(duration: 0.2)) {
                defer {
                    updateValid()
                }
                
                guard !text.isEmpty else {
                    validationResults = []
                    return
                }
                
                validationResults = validationRules.compactMap { $0.validate(text) }
            }
            
            self.debounceTask = nil
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
                    VerifyableTextFieldGridRow(
                        text: $text,
                        valid: $valid
                    ) {
                        Text("Text")
                    } textField: { binding in
                        TextField(text: binding) {
                            Text("Placeholder ...")
                        }
                    }
                        .onTapFocus()
                    Divider()
                    VerifyableTextFieldGridRow(
                        text: $text,
                        valid: $valid,
                        description: "Secure Text"
                    ) { binding in
                        SecureField(text: binding) {
                            Text("Secure Placeholder ...")
                        }
                    }
                        .onTapFocus()
                }
            }
            Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                VerifyableTextFieldGridRow(
                    text: $text,
                    valid: $valid
                ) {
                    Text("Text")
                } textField: { binding in
                    TextField(text: binding) {
                        Text("Placeholder ...")
                    }
                }
                    .onTapFocus(focusedField: _focusedField, fieldIdentifier: .first)
                Divider()
                VerifyableTextFieldGridRow(
                    text: $text,
                    valid: $valid
                ) {
                    Text("Text")
                } textField: { binding in
                    SecureField(text: binding) {
                        Text("Secure Placeholder ...")
                    }
                }
                    .onTapFocus(focusedField: _focusedField, fieldIdentifier: .first)
            }
                .padding(32)
        }
            .background(Color(.systemGroupedBackground))
    }
}
