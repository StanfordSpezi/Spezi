//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_exported import Contacts
import SwiftUI


/// A ``Contact`` encodes the contact information.
public struct Contact {
    let id = UUID()
    /// The name of the individual. Ideally provide at least a first and given name.
    public let name: PersonNameComponents
    /// The image of the ``Contact``.
    public let image: Image?
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
    
    
    /// - Parameters:
    ///   - id: Identiifer of the `Contact` instance.
    ///   - name: The name of the individual. Ideally provide at least a first and given name.
    ///   - image: The image of the ``Contact``.
    ///   - title: The title of the individual.
    ///   - description: The desciption of the individual.
    ///   - organization: The organization of the individual.
    ///   - address: The address of the individual.
    ///   - contactOptions: The contact options of the individual.
    public init( // swiftlint:disable:this function_default_parameter_at_end
        // We want the id to be the first parameter even though it has a default value as it is the primary element identifying a `Contact`.
        id: UUID = UUID(),
        name: PersonNameComponents,
        image: Image? = nil,
        title: String? = nil,
        description: String? = nil,
        organization: String? = nil,
        address: CNPostalAddress? = nil,
        contactOptions: [ContactOption] = []
    ) {
        self.image = image
        self.name = name
        self.title = title
        self.description = description
        self.organization = organization
        self.address = address
        self.contactOptions = contactOptions
    }
}


#if DEBUG
extension Contact {
    static var mock: Contact {
        Contact(
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
    }
}
#endif
