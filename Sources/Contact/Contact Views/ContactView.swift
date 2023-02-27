//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Contacts
import MessageUI
import SwiftUI
import Views


/// A ``ContactView`` enables the display of contact information as defined by a ``Contact``.
public struct ContactView: View {
    private let contact: Contact
    
    @State private var contactGridWidth: CGFloat = 300
    @State private var contentElementWidth: CGFloat = 100
    
    
    private var contactOptions: (grid: some RandomAccessCollection<ContactOption>, leftOverStack: some RandomAccessCollection<ContactOption>) {
        let columnCount = Int(contactGridWidth / contentElementWidth)
        let (numberOfRows, leftOverElements) = contact.contactOptions.count.quotientAndRemainder(dividingBy: columnCount)
        return (contact.contactOptions.dropLast(leftOverElements), contact.contactOptions.dropFirst(columnCount * numberOfRows))
    }
    
    public var body: some View {
        VStack {
            header
            Divider()
            if let description = contact.description {
                Label(description, textStyle: .subheadline)
                    .padding(.vertical, 4)
            }
            HorizontalGeometryReader { _ in
                contactSection
            }
                .onPreferenceChange(WidthPreferenceKey.self) { gridWidth in
                    contactGridWidth = gridWidth
                }
            addressButton
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            UserProfileView(name: contact.name) {
                contact.image
            }
                .frame(height: 40)
            Spacer()
                .frame(width: 16)
            VStack(alignment: .leading, spacing: 2) {
                Text(contact.name.formatted(.name(style: .long)))
                    .font(.title3.bold())
                HStack(spacing: 0) {
                    if let title = contact.title {
                        Text(title)
                    }
                    if contact.title != nil && contact.organization != nil {
                        Text(" - ")
                    }
                    if let organization = contact.organization {
                        Text(organization)
                    }
                }
                    .foregroundColor(Color(.secondaryLabel))
                    .font(.subheadline)
            }
            Spacer()
        }
            .frame(height: 60)
    }
    
    private var contactSection: some View {
        VStack(spacing: 8) {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 100))],
                alignment: .center,
                spacing: 8
            ) {
                ForEach(contactOptions.grid, id: \.id) { contactOption in
                    HorizontalGeometryReader { elementWidth in
                        contactButton(contactOption)
                            .onPreferenceChange(WidthPreferenceKey.self) { elementWidth in
                                contentElementWidth = elementWidth
                            }
                    }
                }
            }
            if !contactOptions.leftOverStack.isEmpty {
                HStack(spacing: 8) {
                    ForEach(contactOptions.leftOverStack, id: \.id) { contactOption in
                        contactButton(contactOption)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var addressButton: some View {
        if let address = contact.address {
            Button(action: openMaps) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundColor(Color(.systemGroupedBackground))
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CONTACT_ADDRESS", bundle: .module)
                                .foregroundColor(.accentColor)
                            Text(CNPostalAddressFormatter().string(from: address))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color(.label))
                        }
                            .font(.caption)
                        Spacer()
                        Image(systemName: "location.fill")
                            .foregroundColor(.accentColor)
                    }
                        .padding(15)
                }
                    .fixedSize(horizontal: false, vertical: true)
            }
        } else {
            EmptyView()
        }
    }
    
    
    /// A ``ContactView`` enables the display of contact information as defined by a ``Contact``.
    /// - Parameter contact: The ``Contact`` that should be displayed.
    public init(contact: Contact) {
        self.contact = contact
    }
    
    
    private func contactButton(_ contactOption: ContactOption) -> some View {
        Button(action: contactOption.action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(Color(.systemGroupedBackground))
                VStack(spacing: 8) {
                    contactOption.image
                        .font(.title3)
                    Text(contactOption.title)
                        .font(.caption)
                }
                    .foregroundColor(.accentColor)
                    .padding(.vertical, 10)
            }
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func openMaps() {
        guard let address = contact.address,
              let addressString = CNPostalAddressFormatter().string(from: address).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "maps://?address=\(addressString)"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url)
    }
}


#if DEBUG
struct ContactView_Previews: PreviewProvider {
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
    
    
    static var previews: some View {
        ContactView(contact: Self.mock)
    }
}
#endif
