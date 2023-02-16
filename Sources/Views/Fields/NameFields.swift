//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// ``NameFields`` provides two text fields in a grid layout that allow users to enter their given and family name and parses the results in a `PersonNameComponents` instance.
public struct NameFields<FocusedField: Hashable>: View {
    public enum LocalizationDefaults {
        public static var givenName: FieldLocalization {
            FieldLocalization(
                title: String(localized: "NAME_FIELD_GIVEN_NAME_TITLE", bundle: .module),
                placeholder: String(localized: "NAME_FIELD_GIVEN_NAME_PLACEHOLDER", bundle: .module)
            )
        }
        public static var familyName: FieldLocalization {
            FieldLocalization(
                title: String(localized: "NAME_FIELD_FAMILY_NAME_TITLE", bundle: .module),
                placeholder: String(localized: "NAME_FIELD_FAMILY_NAME_PLACEHOLDER", bundle: .module)
            )
        }
    }
    
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
    
    
    /// ``NameFields`` provides two text fields in a grid layout that allow users to enter their given and family name and parses the results in a `PersonNameComponents` instance.
    /// - Parameters:
    ///   - name: Binding containing the `PersonNameComponents` parsed from the fields.
    ///   - givenNameField: The localization of the given name field.
    ///   - familyNameField: The localization of the family name field.
    public init(
        name: Binding<PersonNameComponents>,
        givenNameField: FieldLocalization = LocalizationDefaults.givenName,
        familyNameField: FieldLocalization = LocalizationDefaults.familyName
    ) where FocusedField == UUID {
        self._name = name
        self.givenNameField = givenNameField
        self.givenNameFieldIdentifier = UUID()
        self.familyNameField = familyNameField
        self.familyNameFieldIdentifier = UUID()
        self._focusedState = FocusState()
    }
    
    
    /// ``NameFields`` provides two text fields in a grid layout that allow users to enter their given and family name and parses the results in a `PersonNameComponents` instance.
    /// The initializer allows developers to pass in additional `FocusState` information to control and observe the focus state from outside the view.
    /// - Parameters:
    ///   - name: Binding containing the `PersonNameComponents` parsed from the fields.
    ///   - givenNameField: The localization of the given name field.
    ///   - givenNameFieldIdentifier: The `FocusState` identifier of the given name field.
    ///   - familyNameField: The localization of the family name field.
    ///   - familyNameFieldIdentifier: The `FocusState` identifier of the family name field.
    ///   - focusedState: `FocusState` binding to control and observe the focus state from outside the view.
    public init(
        // swiftlint:disable:previous function_default_parameter_at_end
        // We want to keep the arguments grouped by field to ensure that we have the same order as in the non-focusfield initializer.
        name: Binding<PersonNameComponents>,
        givenNameField: FieldLocalization = LocalizationDefaults.givenName,
        givenNameFieldIdentifier: FocusedField,
        familyNameField: FieldLocalization = LocalizationDefaults.familyName,
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


#if DEBUG
struct NameFields_Previews: PreviewProvider {
    @State private static var name = PersonNameComponents()
    
    
    static var previews: some View {
        NameFields(name: $name)
    }
}
#endif
