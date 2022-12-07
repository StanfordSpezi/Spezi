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

struct TestUser {
    var username: String?
    var password: String?
    var name: PersonNameComponents
    var gender: GenderIdentity?
    var dateOfBirth: Date?
    var imageLoader: () async -> Image?
    
    
    var user: User {
        User(name: name, imageLoader: imageLoader)
    }
}

class TestAccount: Account {
    var testUser: TestUser?
    
    
    override var user: User? {
        get {
            testUser?.user
        }
        set {
            guard let newValue else {
                testUser = nil
                return
            }
            
            guard var testUser else {
                self.testUser = TestUser(name: newValue.name, imageLoader: { await newValue.image })
                return
            }
            
            testUser.name = newValue.name
            testUser.imageLoader = { await newValue.image }
            self.testUser = testUser
        }
    }
    
    override var accountServices: [any AccountService] {
        [
            MockUsernamePasswordAccountService(account: self),
            MockEmailPasswordLoginService(account: self)
        ]
    }
}

class MockUsernamePasswordAccountService: UsernamePasswordAccountService {
    override func login(username: String, password: String) async throws {
        try await Task.sleep(for: .seconds(5))
        await MainActor.run {
            account?.user = User(name: PersonNameComponents(givenName: "Leland", familyName: "Stanford")) {
                try? await Task.sleep(for: .seconds(2))
                return Image(systemName: "person.circle.fill")
            }
        }
    }
}

class MockEmailPasswordLoginService: EmailPasswordLoginService {
    override func login(username: String, password: String) async throws {
        try await Task.sleep(for: .seconds(5))
        await MainActor.run {
            account?.user = User(name: PersonNameComponents(givenName: "Leland", familyName: "Stanford (@Stanford)")) {
                try? await Task.sleep(for: .seconds(2))
                return Image(systemName: "person.circle.fill")
            }
        }
    }
}

struct AccountTestsView: View {
    @EnvironmentObject var account: Account
    @State var showLogin = false
    @State var showSignUp = false
    
    
    var body: some View {
        List {
            if let user = account.user {
                HStack {
                    UserProfileView(user: user)
                        .frame(height: 30)
                    Text(user.name.formatted())
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
            .onChange(of: account) { newAccount in
                if newAccount.user != nil {
                    showLogin = false
                    showSignUp = false
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
