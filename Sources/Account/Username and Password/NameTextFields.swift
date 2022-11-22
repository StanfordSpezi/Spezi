//
//  SwiftUIView.swift
//  
//
//  Created by Paul Shmiedmayer on 11/21/22.
//

import SwiftUI

struct NameTextFields: View {
    private enum Field: Hashable {
        case givenName
        case familyName
    }
    
    
    @Binding private var name: PersonNameComponents
    @FocusState private var focusedField: Field?
    
    
    private var givenNameBinding: Binding<String> {
        Binding {
            name.givenName ?? ""
        } set: { newValue in
            name.givenName = newValue
        }
    }
    
    private var familyNameBinding: Binding<String> {
        Binding {
            name.familyName ?? ""
        } set: { newValue in
            name.familyName = newValue
        }
    }
    
    
    var body: some View {
        Grid {
            DescriptionGridRow {
                Text("NAME_TEXT_FIELD_GIVEN_NAME", bundle: .module)
            } content: {
                TextField(String(localized: "NAME_TEXT_FIELD_GIVEN_NAME_PLACEHOLDER", bundle: .module), text: givenNameBinding)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(.givenName)
            }
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .givenName)
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            DescriptionGridRow {
                Text("NAME_TEXT_FIELD_FAMILY_NAME", bundle: .module)
            } content: {
                TextField(String(localized: "NAME_TEXT_FIELD_FAMILY_NAME_PLACEHOLDER", bundle: .module), text: givenNameBinding)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(.familyName)
            }
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .givenName)
        }
    }
    
    
    init(name: Binding<PersonNameComponents>) {
        self._name = name
    }
}


struct NameTextFields_Previews: PreviewProvider {
    @State private static var name = PersonNameComponents()
    
    
    static var previews: some View {
        VStack {
            Form {
                NameTextFields(name: $name)
            }
                .frame(height: 300)
            NameTextFields(name: $name)
                .padding(32)
        }
        .background(Color(.systemGroupedBackground))
    }
}
