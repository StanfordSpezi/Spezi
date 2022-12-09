//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct NameTextFields: View {
    @Binding private var name: PersonNameComponents
    @FocusState private var focusedField: AccountInputFields?
    @EnvironmentObject var localizationEnvironmentObject: UsernamePasswordAccountService
    private let localization: ConfigurableLocalization<(
        givenName: Localization.Field,
        familyName: Localization.Field
    )>
    
    
    private var givenName: Localization.Field {
        switch localization {
        case .environment:
            return localizationEnvironmentObject.localization.signUp.givenName
        case let .value((givenName, _)):
            return givenName
        }
    }
    
    private var familyName: Localization.Field {
        switch localization {
        case .environment:
            return localizationEnvironmentObject.localization.signUp.familyName
        case let .value((_, familyName)):
            return familyName
        }
    }
    
    
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
                Text(givenName.title)
            } content: {
                TextField(givenName.placeholder, text: givenNameBinding)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(.givenName)
            }
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .givenName)
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            DescriptionGridRow {
                Text(familyName.title)
            } content: {
                TextField(familyName.placeholder, text: familyNameBinding)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(.familyName)
            }
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .familyName)
        }
    }
    
    
    init(
        name: Binding<PersonNameComponents>,
        givenName: Localization.Field,
        familyName: Localization.Field,
        focusState: FocusState<AccountInputFields?> = FocusState<AccountInputFields?>()
    ) {
        self._name = name
        self.localization = .value((givenName, familyName))
        self._focusedField = focusState
    }
    
    
    init(
        name: Binding<PersonNameComponents>,
        focusState: FocusState<AccountInputFields?> = FocusState<AccountInputFields?>()
    ) {
        self._name = name
        self._focusedField = focusState
        self.localization = .environment
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
            .environmentObject(UsernamePasswordAccountService())
            .background(Color(.systemGroupedBackground))
    }
}
