//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


public struct SignUp<Header: View>: View {
    private var header: Header
    
    
    public var body: some View {
        AccountServicesView(header: header) { accountService in
            accountService.signUpButton
        }
            .navigationTitle(String(localized: "SIGN_UP", bundle: .module))
    }
    
    
    public init() where Header == EmptyView {
        self.header = EmptyView()
    }
    
    public init(header: Header) {
        self.header = header
    }
}


struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Login()
        }
            .environmentObject(Account())
    }
}