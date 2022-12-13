//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import SwiftUI


/// <#Description#>
public struct ContactCard: View {
    private let contact: Contact
    
    
    public var body: some View {
        ContactView(contact: contact)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.systemBackground))
                    .shadow(radius: 5)
            }
    }
    
    
    /// <#Description#>
    /// - Parameter contact: <#contact description#>
    public init(contact: Contact) {
        self.contact = contact
    }
}


struct ContactCard_Previews: PreviewProvider {
    static var previews: some View {
        ContactCard(contact: .mock)
            .padding()
    }
}
