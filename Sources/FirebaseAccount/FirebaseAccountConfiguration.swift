//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Account
import CardinalKit
@_exported import class FirebaseAuth.User
import class FirebaseAuth.Auth
import protocol FirebaseAuth.AuthStateDidChangeListenerHandle
import FirebaseConfiguration
import FirebaseCore
import Foundation


/// Configures Firebase Auth `AccountService`s that can be used in any views of the `Account` module.
///
/// The ``FirebaseAccountConfiguration`` offers a ``user`` property to access the current Firebase Auth user from, e.g., a SwiftUI view's environment:
/// ```
/// @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration</* ... */>
/// ```
///
/// The ``FirebaseAccountConfiguration`` can, e.g., be used to to connect to the Firebase Auth emulator:
/// ```
/// class ExampleAppDelegate: CardinalKitAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: /* ... */) {
///             FirebaseAccountConfiguration(emulatorSettings: (host: "localhost", port: 9099))
///             // ...
///         }
///     }
/// }
/// ```
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
    
    
    /// - Parameters:
    ///   - emulatorSettings: The emulator settings. The default value is `nil`, connecting the FirebaseAccount module to the Firebase Auth cloud instance.
    ///   - authenticationMethods: The authentication methods that should be supported.
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
                self.updateSignedOut()
                return
            }
            
            self.updateSignedIn(user)
        }
        
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { _, error in
            guard error == nil else {
                self.updateSignedOut()
                return
            }
        }
    }
    
    private func updateSignedOut() {
        Task {
            await MainActor.run {
                self.user = nil
                self.account.signedIn = false
            }
        }
    }
    
    private func updateSignedIn(_ user: User) {
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
