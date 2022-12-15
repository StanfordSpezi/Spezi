//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


public struct NameFields<FocusedField: Hashable>: View {
    private let givenNameField: FieldLocalization
    private let givenNameFieldIdentifier: FocusedField
    private let familyNameField: FieldLocalization
    private let familyNameFieldIdentifier: FocusedField
    
    @FocusState private var focusedState: FocusedField?
    @Binding private var name: PersonNameComponents
    
    
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
    
    
    public var body: some View {
        Grid {
            DescriptionGridRow {
                Text(givenNameField.title)
            } content: {
                TextField(givenNameField.placeholder, text: givenNameBinding)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(.givenName)
            }
                .onTapFocus(focusedField: _focusedState, fieldIdentifier: givenNameFieldIdentifier)
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            DescriptionGridRow {
                Text(familyNameField.title)
            } content: {
                TextField(familyNameField.placeholder, text: familyNameBinding)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(.familyName)
            }
                .onTapFocus(focusedField: _focusedState, fieldIdentifier: familyNameFieldIdentifier)
        }
    }
    
    
    public init(
        name: Binding<PersonNameComponents>,
        givenNameField: FieldLocalization = FieldLocalization(title: "NAME_FIELD_GIVEN_NAME_TITLE", placeholder: "NAME_FIELD_GIVEN_NAME_PLACEHOLDER"),
        familyNameField: FieldLocalization = FieldLocalization(title: "NAME_FIELD_FAMILY_NAME_TITLE", placeholder: "NAME_FIELD_FAMILY_NAME_PLACEHOLDER")
    ) where FocusedField == UUID {
        self._name = name
        self.givenNameField = givenNameField
        self.givenNameFieldIdentifier = UUID()
        self.familyNameField = familyNameField
        self.familyNameFieldIdentifier = UUID()
        self._focusedState = FocusState()
    }
    
    
    public init(
        name: Binding<PersonNameComponents>,
        givenNameField: FieldLocalization,
        givenNameFieldIdentifier: FocusedField,
        familyNameField: FieldLocalization,
        familyNameFieldIdentifier: FocusedField,
        focusedState: FocusState<FocusedField?>
    ) {
        self._name = name
        self.givenNameField = givenNameField
        self.givenNameFieldIdentifier = givenNameFieldIdentifier
        self.familyNameField = familyNameField
        self.familyNameFieldIdentifier = familyNameFieldIdentifier
        self._focusedState = focusedState
    }
}


struct NameFields_Previews: PreviewProvider {
    @State private static var name = PersonNameComponents()
    
    
    static var previews: some View {
        NameFields(name: $name)
    }
}
