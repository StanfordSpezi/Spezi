//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Contact
import SwiftUI


struct ContactsTestsView: View {
    static let mock = Contact(
        name: PersonNameComponents(givenName: "Paul", familyName: "Schmiedmayer"),
        image: Image(systemName: "figure.wave.circle"),
        title: "A Title",
        description: """
        This is a description of a contact that will be displayed. It might even be longer than what has to be displayed in the contact card.
        Why is this text so long, how much can you tell about one person?
        """,
        organization: "Stanford University",
        address: {
            let address = CNMutablePostalAddress()
            address.country = "USA"
            address.state = "CA"
            address.postalCode = "94305"
            address.city = "Stanford"
            address.street = "450 Serra Mall"
            return address
        }(),
        contactOptions: [
            .call("+1 (234) 567-891"),
            .call("+1 (234) 567-892"),
            .text("+1 (234) 567-893"),
            .email(addresses: ["lelandstanford@stanford.edu"], subject: "Hi Leland!"),
            ContactOption(image: Image(systemName: "icloud.fill"), title: "Cloud", action: { })
        ]
    )
    
    
    var body: some View {
        ContactsList(contacts: [ContactsTestsView.mock, ContactsTestsView.mock])
            .navigationTitle("Contacts")
            .background(Color(.systemGroupedBackground))
    }
}


#if DEBUG
struct ContactsTestsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContactsList(contacts: [ContactsTestsView.mock, ContactsTestsView.mock, ContactsTestsView.mock])
        }
    }
}
#endif
