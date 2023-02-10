//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Account
import CardinalKit
import FirebaseAccount
import FirebaseAuth
import SwiftUI
import Views


struct FirebaseAccountTestsView: View {
    @EnvironmentObject var firebaseAccount: FirebaseAccountConfiguration<TestAppStandard>
    @EnvironmentObject var account: Account
    @State var showLogin = false
    @State var showSignUp = false
    
    
    var body: some View {
        List {
            if account.signedIn {
                HStack {
                    if let displayName = firebaseAccount.user?.displayName,
                       let name = try? PersonNameComponents(displayName) {
                        UserProfileView(name: name)
                            .frame(height: 30)
                    }
                    if let email = firebaseAccount.user?.email {
                        Text(email)
                    }
                }
            }
            Button("Login") {
                showLogin.toggle()
            }
                .disabled(account.signedIn)
            Button("Sign Up") {
                showSignUp.toggle()
            }
                .disabled(account.signedIn)
            Button("Logout", role: .destructive) {
                try? Auth.auth().signOut()
            }
                .disabled(!account.signedIn)
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
}
