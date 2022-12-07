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

actor User: ObservableObject {
    @MainActor @Published var username: String?
    @MainActor @Published var name: PersonNameComponents = PersonNameComponents()
    @MainActor @Published var gender: GenderIdentity?
    @MainActor @Published var dateOfBirth: Date?
    
    
    init(
        username: String? = nil,
        name: PersonNameComponents = PersonNameComponents(),
        gender: GenderIdentity? = nil,
        dateOfBirth: Date? = nil
    ) {
        Task { @MainActor in
            self.username = username
            self.name = name
            self.gender = gender
            self.dateOfBirth = dateOfBirth
        }
    }
}


actor TestAccountConfiguration<ComponentStandard: Standard>: Component, ObservableObjectProvider {
    private let account: Account
    private let user: User
    
    
    nonisolated var observableObjects: [any ObservableObject] {
        [
            account,
            user
        ]
    }
    
    
    init() {
        self.user = User()
        let accountServices: [any AccountService] = [
            MockUsernamePasswordAccountService(user: user),
            MockEmailPasswordAccountService(user: user)
        ]
        self.account = Account(accountServices: accountServices)
    }
}


class MockUsernamePasswordAccountService: UsernamePasswordAccountService {
    let user: User
    
    
    override func login(username: String, password: String) async throws {
        try await Task.sleep(for: .seconds(5))
        await MainActor.run {
            account?.signedIn = true
            user.username = username
        }
    }
    
    
    init(user: User) {
        self.user = user
        super.init()
    }
}

class MockEmailPasswordAccountService: EmailPasswordAccountService {
    let user: User
    
    
    override func login(username: String, password: String) async throws {
        try await Task.sleep(for: .seconds(5))
        await MainActor.run {
            account?.signedIn = true
            user.username = username
        }
    }
    
    
    init(user: User) {
        self.user = user
        super.init()
    }
}

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
