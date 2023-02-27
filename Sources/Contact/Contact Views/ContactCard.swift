//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import SwiftUI


struct ContactCard: View {
    private let contact: Contact
    
    
    var body: some View {
        ContactView(contact: contact)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.systemBackground))
                    .shadow(radius: 5)
            }
    }
    
    
    init(contact: Contact) {
        self.contact = contact
    }
}


#if DEBUG
struct ContactCard_Previews: PreviewProvider {
    static var previews: some View {
        ContactCard(contact: ContactView_Previews.mock)
            .padding()
    }
}
#endif
