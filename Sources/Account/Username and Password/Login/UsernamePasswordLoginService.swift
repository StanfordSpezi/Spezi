//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


class UsernamePasswordLoginService: AccountService, ObservableObject {
    weak var account: Account?
    
    
    open var localization: Localization {
        Localization.default
    }
    
    open var loginButton: AnyView {
        AnyView(
            NavigationLink {
                UsernamePasswordLoginView()
                    .environmentObject(self as UsernamePasswordLoginService)
            } label: {
                AccountServiceButton {
                    Image(systemName: "ellipsis.rectangle")
                        .font(.title2)
                    Text(localization.signUp.buttonTitle)
                }
            }
        )
    }
    
    open var resetPasswordButton: AnyView {
        AnyView(
            Button(localization.resetPassword.buttonTitle) {
                print("Reset Password ...")
            }
        )
    }
    
    open var signUpButton: AnyView {
        AnyView(
            Button(localization.signUp.buttonTitle) {
                print("Sign Up Button")
            }
        )
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
}
