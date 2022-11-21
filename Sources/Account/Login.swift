//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


public struct Login<Header: View>: View {
    @EnvironmentObject var account: Account
    
    private var header: Header
    
    
    public var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                VStack {
                    header
                    Spacer(minLength: 0)
                    VStack(spacing: 16) {
                        ForEach(account.loginServices, id: \.id) { loginService in
                            loginService.loginButton
                        }
                    }
                        .padding(16)
                }
                    .frame(minHeight: proxy.size.height)
                    .frame(maxWidth: .infinity)
            }
        }
            .navigationTitle(String(localized: "LOGIN", bundle: .module))
    }
    
    
    public init() where Header == EmptyView {
        self.header = EmptyView()
    }
    
    public init(header: Header) {
        self.header = header
    }
}


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Login()
        }
            .environmentObject(Account())
    }
}
