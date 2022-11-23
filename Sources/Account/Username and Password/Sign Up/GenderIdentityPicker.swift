//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct GenderIdentityPicker: View {
    @Binding private var genderIdentity: GenderIdentity
    @FocusState private var focusedField: LoginAndSignUpFields?
    
    var body: some View {
//        Menu {
//            ForEach(GenderIdentity.allCases) { genderIdentity in
//                Button(genderIdentity.localizedDescription) {
//                    self.genderIdentity = genderIdentity
//                }
//            }
//        } label: {
//            HStack {
//                Text(genderIdentity.localizedDescription)
//                Image(systemName: "chevron.up.chevron.down")
//                    .font(.footnote)
//            }
//                .foregroundColor(.secondary)
//        }
//        .contentShape(Rectangle())
        Picker(selection: $genderIdentity) {
            ForEach(GenderIdentity.allCases) { genderIdentity in
                Text(genderIdentity.localizedDescription)
                    .id(genderIdentity.id)
            }
        } label: {
            Text(String(localized: "GENDER_IDENTITY", bundle: .module))
                .fontWeight(.semibold)
        }
    }
    
    
    init(genderIdentity: Binding<GenderIdentity>) {
        self._genderIdentity = genderIdentity
    }
}


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
        .background(Color(.systemGroupedBackground))
    }
}
