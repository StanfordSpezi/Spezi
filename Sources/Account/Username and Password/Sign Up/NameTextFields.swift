//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct NameTextFields: View {
    @Binding private var name: PersonNameComponents
    @FocusState private var focusedField: AccountInputFields?
    @EnvironmentObject var localizationEnvironmentObject: UsernamePasswordAccountService
    private let localization: ConfigurableLocalization<(
        givenName: FieldLocalization,
        familyName: FieldLocalization
    )>
    
    
    private var givenName: FieldLocalization {
        switch localization {
        case .environment:
            return localizationEnvironmentObject.localization.signUp.givenName
        case let .value((givenName, _)):
            return givenName
        }
    }
    
    private var familyName: FieldLocalization {
        switch localization {
        case .environment:
            return localizationEnvironmentObject.localization.signUp.familyName
        case let .value((_, familyName)):
            return familyName
        }
    }
    
    
    var body: some View {
        Views.NameFields(
            name: $name,
            givenNameField: givenName,
            givenNameFieldIdentifier: AccountInputFields.givenName,
            familyNameField: familyName,
            familyNameFieldIdentifier: AccountInputFields.familyName,
            focusedState: _focusedField
        )
    }
    
    
    init(
        name: Binding<PersonNameComponents>,
        givenName: FieldLocalization,
        familyName: FieldLocalization,
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


#if DEBUG
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
#endif
