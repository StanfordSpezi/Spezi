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
        GridRow {
            Text(title)
                .fontWeight(.semibold)
                .gridColumnAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.trailing, 8)
            VStack(spacing: 0) {
                TextField(placeholder, text: $text)
                    .frame(maxWidth: .infinity)
                    .focused($focusedField, equals: fieldIdentifier)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
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
            .contentShape(Rectangle())
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
                Grid {
                    VerifyableTextGridRow(
                        text: $text,
                        focusedField: _focusedField,
                        valid: $valid,
                        title: "Text",
                        placeholder: "Placeholder ...",
                        fieldIdentifier: .first
                    )
                    Divider()
                    VerifyableTextGridRow(
                        text: $text,
                        focusedField: _focusedField,
                        valid: $valid,
                        title: "Text",
                        placeholder: "Placeholder ...",
                        fieldIdentifier: .second
                    )
                }
            }
            Grid {
                VerifyableTextGridRow(
                    text: $text,
                    valid: $valid,
                    title: "Text",
                    placeholder: "Placeholder ..."
                )
                Divider()
                VerifyableTextGridRow(
                    text: $text,
                    valid: $valid,
                    title: "Text",
                    placeholder: "Placeholder ..."
                )
            }
                .padding(32)
        }
            .background(Color(.systemGroupedBackground))
    }
}
