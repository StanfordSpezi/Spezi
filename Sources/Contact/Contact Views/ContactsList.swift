//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// <#Description#>
public struct ContactsList: View {
    private let contacts: [Contact]
    
    
    public var body: some View {
        ScrollView(.vertical) {
            ForEach(contacts, id: \.id) { contact in
                ContactCard(contact: contact)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
            }
                .padding(.vertical, 6)
        }
    }
    
    
    /// <#Description#>
    /// - Parameter contact: <#contact description#>
    public init(contacts: [Contact]) {
        self.contacts = contacts
    }
}

struct ContactsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContactsList(contacts: [.mock, .mock, .mock])
                .navigationTitle("Contacts")
                .background(Color(.systemGroupedBackground))
        }
    }
}
