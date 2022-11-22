//
//  SwiftUIView.swift
//  
//
//  Created by Paul Shmiedmayer on 11/21/22.
//

import SwiftUI


struct TextGridRow<FocusedField: Hashable>: View {
    private let title: String
    private let placeholder: String
    private let fieldIdentifier: FocusedField
    
    
    @Binding private var text: String
    @FocusState private var focusedField: FocusedField?
    
    
    var body: some View {
        EmptyView()
        VerifyableTextGridRow(
            text: $text,
            focusedField: _focusedField,
            valid: .constant(true),
            title: title,
            placeholder: placeholder,
            fieldIdentifier: fieldIdentifier
        )
    }
    
    
    init(
        text: Binding<String>,
        focusedField: FocusState<FocusedField?>,
        title: String,
        placeholder: String,
        fieldIdentifier: FocusedField
    ) {
        self._text = text
        self._focusedField = focusedField
        self.title = title
        self.placeholder = placeholder
        self.fieldIdentifier = fieldIdentifier
    }
    
    
    init(
        text: Binding<String>,
        title: String,
        placeholder: String
    ) where FocusedField == UUID {
        self._text = text
        self._focusedField = FocusState<FocusedField?>()
        self.title = title
        self.placeholder = placeholder
        self.fieldIdentifier = UUID()
    }
}



struct TextGridRow_Previews: PreviewProvider {
    @State private static var text: String = ""
    @FocusState private static var focusedField: Int?
    
    
    static var previews: some View {
        VStack {
            Form {
                Grid {
                    TextGridRow(
                        text: $text,
                        title: "Text",
                        placeholder: "Placeholder ..."
                    )
                    Divider()
                    TextGridRow(
                        text: $text,
                        focusedField: _focusedField,
                        title: "Text",
                        placeholder: "Placeholder ...",
                        fieldIdentifier: 1
                    )
                }
            }
                .frame(height: 300)
            Grid {
                TextGridRow(
                    text: $text,
                    title: "Text",
                    placeholder: "Placeholder ..."
                )
                Divider()
                TextGridRow(
                    text: $text,
                    focusedField: _focusedField,
                    title: "Text",
                    placeholder: "Placeholder ...",
                    fieldIdentifier: 1
                )
            }
                .padding(32)
        }
            .background(Color(.systemGroupedBackground))
    }
}

