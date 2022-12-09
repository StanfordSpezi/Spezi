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
    
    
    var body: some View {
        List {
            if account.signedIn {
                HStack {
                    Text(user.username ?? "")
                }
            }
            Button("Login") {
                showLogin.toggle()
            }
        }
            .sheet(isPresented: $showLogin) {
                NavigationStack {
                    Login()
                }
            }
            .onChange(of: account.signedIn) { signedIn in
                if signedIn {
                    showLogin = false
                }
            }
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
