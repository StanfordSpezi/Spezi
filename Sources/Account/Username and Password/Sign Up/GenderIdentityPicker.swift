//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct GenderIdentityPicker: View {
    @Binding private var genderIdentity: GenderIdentity
    @EnvironmentObject private var localizationEnvironmentObject: UsernamePasswordAccountService
    private let localization: ConfigurableLocalization<String>
    
    
    private var genderIdentityTitle: String {
        switch localization {
        case .environment:
            return localizationEnvironmentObject.localization.signUp.genderIdentityTitle
        case let .value(genderIdentityTitle):
            return genderIdentityTitle
        }
    }
    
    var body: some View {
        Picker(
            selection: $genderIdentity,
            content: {
                ForEach(GenderIdentity.allCases) { genderIdentity in
                    Text(String(localized: genderIdentity.localizedStringResource))
                        .tag(genderIdentity)
                }
            }, label: {
                Text(genderIdentityTitle)
                    .fontWeight(.semibold)
            }
        )
    }
    
    
    init(genderIdentity: Binding<GenderIdentity>, title: String) {
        self._genderIdentity = genderIdentity
        self.localization = .value(title)
    }
    
    
    init(genderIdentity: Binding<GenderIdentity>) {
        self._genderIdentity = genderIdentity
        self.localization = .environment
    }
}


#if DEBUG
struct GenderIdentityPicker_Previews: PreviewProvider {
    @State private static var genderIdentity: GenderIdentity = .male
    
    
    static var previews: some View {
        VStack {
            Form {
                Grid {
                    GenderIdentityPicker(genderIdentity: $genderIdentity)
                }
            }
                .frame(height: 200)
            Grid {
                GenderIdentityPicker(genderIdentity: $genderIdentity)
            }
                .padding(32)
        }
            .environmentObject(UsernamePasswordAccountService())
            .background(Color(.systemGroupedBackground))
    }
}
#endif
