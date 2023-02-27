//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Account
import CardinalKit
import SwiftUI
import Views


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
}


#if DEBUG
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
#endif
