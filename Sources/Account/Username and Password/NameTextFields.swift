//
//  SwiftUIView.swift
//  
//
//  Created by Paul Shmiedmayer on 11/21/22.
//

import SwiftUI

struct NameTextFields: View {
    enum Field: Hashable {
        case givenName
        case familyName
    }
    
    
    @Binding var name: PersonNameComponents
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
            GridRow {
                Text("NAME_TEXT_FIELD_GIVEN_NAME", bundle: .module)
                    .fontWeight(.semibold)
                    .gridColumnAlignment(.leading)
                TextField(String(localized: "NAME_TEXT_FIELD_GIVEN_NAME_PLACEHOLDER", bundle: .module), text: givenNameBinding)
                    .frame(maxWidth: .infinity)
                    .focused($focusedField, equals: .givenName)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = .givenName
                }
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            GridRow {
                Text("NAME_TEXT_FIELD_FAMILY_NAME", bundle: .module)
                    .fontWeight(.semibold)
                    .gridColumnAlignment(.leading)
                TextField(String(localized: "NAME_TEXT_FIELD_FAMILY_NAME_PLACEHOLDER", bundle: .module), text: familyNameBinding)
                    .frame(maxWidth: .infinity)
                    .focused($focusedField, equals: .familyName)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = .familyName
                }
        }
    }
}

struct NameTextFields_Previews: PreviewProvider {
    @State private static var name = PersonNameComponents()
    
    
    static var previews: some View {
        VStack {
            Form {
                NameTextFields(name: $name)
                    .border(.red)
            }
                .frame(height: 200)
            NameTextFields(name: $name)
                .border(.red)
        }
        .background(Color(.systemGroupedBackground))
    }
}
