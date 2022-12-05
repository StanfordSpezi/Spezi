//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


class UsernamePasswordAccountService: AccountService, ObservableObject {
    weak var account: Account?
    
    
    var localization: Localization {
        Localization.default
    }
    
    var loginButton: AnyView {
        button(localization.signUp.buttonTitle, destination: UsernamePasswordLoginView())
    }
    
    var signUpButton: AnyView {
        button(localization.signUp.buttonTitle, destination: UsernamePasswordSignUpView())
    }
    
    var resetPasswordButton: AnyView {
        button(localization.resetPassword.buttonTitle, destination: Text("Reset Password ..."))
    }
    
    
    required init(account: Account) {
        self.account = account
    }
    
    
    func login(username: String, password: String) async throws {
        try await Task.sleep(for: .seconds(5))
        account?.user = User(name: PersonNameComponents(givenName: "Leland", familyName: "Stanford")) {
            try? await Task.sleep(for: .seconds(2))
            return Image(systemName: "person.fill")
        }
    }
    
    
    func button<V: View>(_ title: String, destination: V) -> AnyView {
        AnyView(
            NavigationLink {
                destination
                    .environmentObject(self as UsernamePasswordAccountService)
            } label: {
                AccountServiceButton {
                    Image(systemName: "ellipsis.rectangle")
                        .font(.title2)
                    Text(title)
                }
            }
        )
    }
}
