//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Account
import CardinalKit
import SwiftUI

class TestAccountConfiguration<ComponentStandard: Standard>: Component, ObservableObjectComponent {
    var observableObject: Account {
        TestAccount()
    }
}

class TestAccount: Account {
    override var accountServices: [any AccountService] {
        [
            UsernamePasswordAccountService(account: self),
            EmailPasswordLoginService(account: self)
        ]
    }
}


struct AccountTestsView: View {
    var body: some View {
        Group {
            List {
                NavigationLink("User Profile View") {
                    profileViews
                }
                NavigationLink("Login") {
                    Login()
                }
                NavigationLink("Sign Up") {
                    SignUp()
                }
            }
        }
    }
    
    
    @ViewBuilder
    var profileViews: some View {
        UserProfileView(user: User(name: PersonNameComponents(givenName: "Paul", familyName: "Schmiedmayer")))
            .frame(width: 100)
        UserProfileView(
            user: User(
                name: PersonNameComponents(givenName: "Leland", familyName: "Stanford"),
                imageLoader: {
                    try? await Task.sleep(for: .seconds(1))
                    return Image(systemName: "person.crop.artframe")
                }
            )
        )
            .frame(width: 200)
    }
}


struct AccountTestsView_Previews: PreviewProvider {
    @StateObject private static var account: Account = TestAccount()
    
    static var previews: some View {
        NavigationStack {
            AccountTestsView()
        }
            .environmentObject(account)
    }
}
