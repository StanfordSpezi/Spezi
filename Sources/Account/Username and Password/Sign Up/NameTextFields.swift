//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct NameTextFields: View {
    @Binding private var name: PersonNameComponents
    @FocusState private var focusedField: LoginAndSignUpFields?
    @EnvironmentObject var localizationEnvironmentObject: UsernamePasswordLoginService
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
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .familyName)
        }
    }
    
    
    init(
        name: Binding<PersonNameComponents>,
        focusState: FocusState<LoginAndSignUpFields?> = FocusState<LoginAndSignUpFields?>(),
        givenName: Localization.Field,
        familyName: Localization.Field
    ) {
        self._name = name
        self._focusedField = focusState
        self.localization = .value((givenName, familyName))
    }
    
    
    init(
        name: Binding<PersonNameComponents>,
        focusState: FocusState<LoginAndSignUpFields?> = FocusState<LoginAndSignUpFields?>()
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
            .environmentObject(UsernamePasswordLoginService(account: Account()))
            .background(Color(.systemGroupedBackground))
    }
}
