//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Account
import CardinalKit
import FirebaseAuth
import FirebaseConfiguration
import FirebaseCore
import Foundation


/// <#Description#>
public final class FirebaseAccountConfiguration<ComponentStandard: Standard>: Component, ObservableObject, ObservableObjectProvider {
    @Dependency private var configureFirebaseApp: ConfigureFirebaseApp
    
    private let emulatorSettings: (host: String, port: Int)?
    private let authenticationMethods: FirebaseAuthAuthenticationMethods
    private let account: Account
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    @MainActor @Published
    public var user: User?
    
    
    public var observableObjects: [any ObservableObject] {
        [
            self,
            account
        ]
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - emulatorSettings: <#emulatorSettings description#>
    ///   - authenticationMethods: <#authenticationMethods description#>
    public init(
        emulatorSettings: (host: String, port: Int)? = nil,
        authenticationMethods: FirebaseAuthAuthenticationMethods = .all
    ) {
        self.emulatorSettings = emulatorSettings
        self.authenticationMethods = authenticationMethods
        
        
        var accountServices: [any AccountService] = []
        if authenticationMethods.contains(.emailAndPassword) {
            accountServices.append(FirebaseEmailPasswordAccountService())
        }
        self.account = Account(accountServices: accountServices)
    }
    
    
    public func configure() {
        if let emulatorSettings {
            Auth.auth().useEmulator(withHost: emulatorSettings.host, port: emulatorSettings.port)
        }
        
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            guard let user else {
                Task {
                    await MainActor.run {
                        self.account.signedIn = false
                    }
                }
                return
            }
            
            Task {
                await MainActor.run {
                    self.user = user
                    if self.account.signedIn == false {
                        self.account.signedIn = true
                    }
                }
            }
        }
    }
}
