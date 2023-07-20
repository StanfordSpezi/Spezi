//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``Configuration`` defines the ``Standard`` and ``Component``s that are used in a Spezi project.
///
/// Ensure that your standard conforms to all protocols enforced by the ``Component``s. If your ``Component``s require protocol conformances
/// you must add them to your custom type conforming to ``Standard`` and passed to the initializer or extend a prebuild standard.
///
/// Use ``Configuration/init(_:)`` to use default empty standard instance only conforming to ``Standard`` if you do not use any ``Component`` requiring custom protocol conformances.
///
///
/// The following example demonstrates the usage of an `ExampleStandard` standard and reusable Spezi modules, including the `HealthKit` and `QuestionnaireDataSource` components:
/// ```swift
/// import Spezi
/// import HealthKit
/// import HealthKitDataSource
/// import Questionnaires
/// import SwiftUI
///
///
/// class ExampleAppDelegate: SpeziAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: ExampleStandard()) {
///             if HKHealthStore.isHealthDataAvailable() {
///                 HealthKit {
///                     CollectSample(
///                         HKQuantityType(.stepCount),
///                         deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
///                     )
///                 }
///             }
///             QuestionnaireDataSource()
///         }
///     }
/// }
/// ```
///
/// The ``Component`` documentation provides more information about the structure of components.
public struct Configuration {
    let spezi: AnySpezi
    

    /// A ``Configuration`` defines the ``Standard`` and ``Component``s that are used in a Spezi project.
    ///
    /// Ensure that your standard conforms to all protocols enforced by the ``Component``s. If your ``Component``s require protocol conformances
    /// you must add them to your custom type conforming to ``Standard`` and passed to the initializer or extend a prebuild standard.
    ///
    /// Use ``Configuration/init(_:)`` to use default empty standard instance only conforming to ``Standard`` if you do not use any ``Component`` requiring custom protocol conformances.
    /// - Parameters:
    ///   - components: The ``Component``s used in the Spezi project. You can define the ``Component``s using the ``ComponentBuilder`` result builder.
    public init<S: Standard>(
        standard: S,
        @ComponentBuilder _ components: () -> ComponentCollection
    ) {
        self.spezi = Spezi<S>(standard: standard, components: components().elements)
    }
    
    
    /// A ``Configuration`` defines the ``Standard`` and ``Component``s that are used in a Spezi project.
    ///
    /// This initializer creates a default empty standard instance only conforming to ``Standard``.
    /// Use ``Configuration/init(standard:_:)`` to provide a custom ``Standard`` instance if you use any ``Component`` requiring custom protocol conformances.
    ///
    /// - Parameters:
    ///   - components: The ``Component``s used in the Spezi project. You can define the ``Component``s using the ``ComponentBuilder`` result builder.
    public init(
        @ComponentBuilder _ components: () -> (ComponentCollection)
    ) {
        self.spezi = Spezi<DefaultStandard>(standard: DefaultStandard(), components: components().elements)
    }
}
