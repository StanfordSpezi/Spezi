//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Contacts
import SwiftUI

/// <#Description#>
public struct Contact {
    let id = UUID()
    /// <#Description#>
    public let image: Image?
    /// <#Description#>
    public let name: PersonNameComponents
    /// <#Description#>
    public let title: String?
    /// <#Description#>
    public let description: String?
    /// <#Description#>
    public let organization: String?
    /// <#Description#>
    public let address: CNPostalAddress?
    /// <#Description#>
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
