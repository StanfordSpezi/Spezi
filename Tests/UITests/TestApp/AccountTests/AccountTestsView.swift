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


struct AccountTestsView: View {
    @EnvironmentObject var account: Account
    @EnvironmentObject var user: User
    @State var showLogin = false
    @State var showSignUp = false
    
    
    var body: some View {
        List {
            if account.signedIn {
                HStack {
                    UserProfileView(name: user.name)
                        .frame(height: 30)
                    Text(user.username ?? user.name.formatted())
                }
            }
            NavigationLink("User Profile View") {
                profileViews
            }
            Button("Login") {
                showLogin.toggle()
            }
            Button("SignUp") {
                showSignUp.toggle()
            }
        }
            .sheet(isPresented: $showLogin) {
                NavigationStack {
                    Login()
                }
            }
            .sheet(isPresented: $showSignUp) {
                NavigationStack {
                    SignUp()
                }
            }
            .onChange(of: account.signedIn) { signedIn in
                if signedIn {
                    showLogin = false
                    showSignUp = false
                }
            }
    }
    
    
    @ViewBuilder
    var profileViews: some View {
        UserProfileView(
            name: PersonNameComponents(givenName: "Paul", familyName: "Schmiedmayer")
        )
            .frame(width: 100)
        UserProfileView(
            name: PersonNameComponents(givenName: "Leland", familyName: "Stanford"),
            imageLoader: {
                try? await Task.sleep(for: .seconds(1))
                return Image(systemName: "person.crop.artframe")
            }
        )
            .frame(width: 200)
    }
}


struct AccountTestsView_Previews: PreviewProvider {
    @StateObject private static var account: Account = {
        let accountServices: [any AccountService] = [
            UsernamePasswordAccountService(),
            EmailPasswordAccountService()
        ]
        return Account(accountServices: accountServices)
    }()
    
    
    static var previews: some View {
        NavigationStack {
            AccountTestsView()
        }
            .environmentObject(account)
    }
}
