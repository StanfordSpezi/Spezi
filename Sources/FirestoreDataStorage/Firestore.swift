//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI


/// The ``Firestore`` module & data storage provider enables the synchronization of data stored in a standard with the Firebase Firestore.
///
/// You can configure the ``Firestore`` module in the `CardinalKitAppDelegate` including a chain of adapter from your standard basetype and
/// removal context to ``FirestoreElement`` and ``FirestoreRemovalContext`` instances.
/// ```swift
/// class FirestoreExampleDelegate: CardinalKitAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: ExampleStandard()) {
///             Firestore(settings: .emulator) {
///                 // ... chain of `Adapter`s
///             }
///         }
///     }
/// }
/// ```
public actor Firestore<ComponentStandard: Standard>: Module, DataStorageProvider {
    public typealias FirestoreAdapter = any FirestoreElementAdapter<ComponentStandard.BaseType, ComponentStandard.RemovalContext>


    private let settings: FirestoreSettings
    private let adapter: FirestoreAdapter

    
    /// - Parameter settings: The firestore settings according to the [Firebase Firestore Swift Package](https://firebase.google.com/docs/reference/swift/firebasefirestore/api/reference/Classes/FirestoreSettings)
    public init(settings: FirestoreSettings = FirestoreSettings())
        where ComponentStandard.BaseType: FirestoreElement, ComponentStandard.RemovalContext: FirestoreRemovalContext {
        self.adapter = DefaultFirestoreElementAdapter()
        self.settings = settings
    }
    
    /// - Parameters:
    ///   - adapter: A chain of adapter from your standard basetype and
    /// removal context to ``FirestoreElement`` and ``FirestoreRemovalContext`` instances.
    ///   - settings: The firestore settings according to the [Firebase Firestore Swift Package](https://firebase.google.com/docs/reference/swift/firebasefirestore/api/reference/Classes/FirestoreSettings)
    public init(adapter: FirestoreAdapter, settings: FirestoreSettings = FirestoreSettings()) {
        self.adapter = adapter
        self.settings = settings
    }
    
    
    nonisolated public func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) {
        FirebaseApp.configure()
        
        FirebaseFirestore.Firestore.firestore().settings = self.settings
        
        _ = FirebaseFirestore.Firestore.firestore()
    }
    
    public func process(_ element: DataChange<ComponentStandard.BaseType, ComponentStandard.RemovalContext>) async throws {
        switch element {
        case let .addition(element):
            let firebaseElement = try await adapter.transform(element: element)
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                do {
                    let firestore = FirebaseFirestore.Firestore.firestore()
                    try firestore
                        .collection(firebaseElement.collectionPath)
                        .document(firebaseElement.id)
                        .setData(from: firebaseElement, merge: false) { error in
                            if let error {
                                continuation.resume(throwing: error)
                            } else {
                                continuation.resume()
                            }
                        }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        case let .removal(removalContext):
            let firebaseRemovalContext = try await adapter.transform(removalContext: removalContext)
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                let firestore = FirebaseFirestore.Firestore.firestore()
                firestore
                    .collection(firebaseRemovalContext.collectionPath)
                    .document(firebaseRemovalContext.id)
                    .delete { error in
                        if let error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume()
                        }
                    }
            }
        }
    }
}
