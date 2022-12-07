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

actor TestAccountConfiguration<ComponentStandard: Standard>: Component, ObservableObjectComponent {
    private let account: Account
    
    nonisolated var observableObject: Account {
        account
    }
    
    
    init() {
        let accountServices: [any AccountService] = [
            MockUsernamePasswordAccountService(),
            MockEmailPasswordAccountService()
        ]
        self.account = Account(accountServices: accountServices)
    }
}

struct TestUser: Sendable {
    var username: String?
    var password: String?
    var name: PersonNameComponents
    var gender: GenderIdentity?
    var dateOfBirth: Date?
}


class MockUsernamePasswordAccountService: UsernamePasswordAccountService {
    override func login(username: String, password: String) async throws {
        try await Task.sleep(for: .seconds(5))
        await MainActor.run {
            account?.signedIn = true
        }
    }
}

class MockEmailPasswordAccountService: EmailPasswordAccountService {
    override func login(username: String, password: String) async throws {
        try await Task.sleep(for: .seconds(5))
        await MainActor.run {
            account?.signedIn = true
        }
    }
}

struct AccountTestsView: View {
    @EnvironmentObject var account: Account
    @State var showLogin = false
    @State var showSignUp = false
    
    
    var body: some View {
        List {
//            if let user = account.user {
//                HStack {
//                    UserProfileView(user: user)
//                        .frame(height: 30)
//                    Text(user.name.formatted())
//                }
//            }
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
