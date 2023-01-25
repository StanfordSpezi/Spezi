//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
@testable import Contact
import SwiftUI


struct ContactsTestsView: View {
    var body: some View {
        ContactsList(contacts: [ContactView_Previews.mock, ContactView_Previews.mock])
            .navigationTitle("Contacts")
            .background(Color(.systemGroupedBackground))
    }
}


struct ContactsTestsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContactsList(contacts: [ContactView_Previews.mock, ContactView_Previews.mock, ContactView_Previews.mock])
        }
    }
}
