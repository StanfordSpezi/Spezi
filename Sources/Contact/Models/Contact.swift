//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Contacts
import SwiftUI

/// A ``Contact`` encodes the contact information.
public struct Contact {
    let id = UUID()
    /// The image of the Contact.
    public let image: Image?
    /// The name of the individual. Ideally provide at least a first and given name.
    public let name: PersonNameComponents
    /// The title of the individual.
    public let title: String?
    /// The desciption of the individual.
    public let description: String?
    /// The organization of the individual.
    public let organization: String?
    /// The address of the individual.
    public let address: CNPostalAddress?
    /// The contact options of the individual.
    public let contactOptions: [ContactOption]
}


#if DEBUG
extension Contact {
    static var mock: Contact {
        Contact(
            image: Image(systemName: "figure.wave.circle"),
            name: PersonNameComponents(givenName: "Paul", familyName: "Schmiedmayer"),
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
    }
}
#endif
