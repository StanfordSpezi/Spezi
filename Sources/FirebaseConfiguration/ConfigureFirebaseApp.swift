//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FirebaseCore


/// Shared component to serve as a single point to configure the Firebase set of dependencies.
///
/// The ``configure()`` method calls `FirebaseApp.configure()`.
/// Use the `@Dependency` property wrapper to define a dependency on this component and ensure that `FirebaseApp.configure()` is called before any
/// other Firebase-related components:
/// ```swift
/// public final class YourFirebaseComponent<ComponentStandard: Standard>: Component {
///     @Dependency private var configureFirebaseApp: ConfigureFirebaseApp
///
///     // ...
/// }
/// ```
public final class ConfigureFirebaseApp<ComponentStandard: Standard>: Component, DefaultInitializable {
    public init() {}
    
    
    public func configure() {
        FirebaseApp.configure()
    }
}
