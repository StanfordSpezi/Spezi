//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``Configuration`` defines the ``Standard`` and ``Component``s that are used in a Spezi project.
///
/// Register your different ``Component``s (or more sophisticated ``Module``s) using the ``SpeziAppDelegate/configuration`` property, e.g., using the
/// `FHIR` standard integrated into the Spezi Swift Package.
///
/// The ``Configuration`` initializer requires a ``Standard`` that is used in the Spezi project.
/// The standard defines a shared repository to facilitate communication between different modules.
///
/// The ``Configuration/init(standard:_:)``'s components result builder allows the definition of different components, including conditional statements or loops.
///
/// The following example demonstrates the usage of the `FHIR` standard and different built-in Spezi modules, including the `HealthKit` and `QuestionnaireDataSource` components:
/// ```swift
/// import Spezi
/// import FHIR
/// import HealthKit
/// import HealthKitDataSource
/// import HealthKitToFHIRAdapter
/// import Questionnaires
/// import SwiftUI
///
///
/// class ExampleAppDelegate: SpeziAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: FHIR()) {
///             if HKHealthStore.isHealthDataAvailable() {
///                 HealthKit {
///                     CollectSample(
///                         HKQuantityType(.stepCount),
///                         deliverySetting: .background(.afterAuthorizationAndApplicationWillLaunch)
///                     )
///                 } adapter: {
///                     HealthKitToFHIRAdapter()
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
    /// If no ``Standard`` is provided, Spezi injects a default empty standard instance only conforming to ``Standard``.
    /// Ensure that your standard conforms to all protocols enforced by the ``Component``s. If your ``Component``s require protocol conformances
    /// you must add them to your custom type conforming to ``Standard`` and passed to the initializer or extend a prebuild standard.
    ///
    /// - Parameters:
    ///   - components: The ``Component``s used in the Spezi project. You can define the ``Component``s using the ``ComponentBuilder`` result builder.
    public init<S: Standard>(
        standard: S,
        @ComponentBuilder _ components: () -> (ComponentCollection)
    ) {
        self.spezi = Spezi<S>(standard: standard, components: components().elements)
    }
    
    
    /// A ``Configuration`` defines the ``Standard`` and ``Component``s that are used in a Spezi project.
    ///
    /// If no ``Standard`` is provided, Spezi injects a default empty standard instance only conforming to ``Standard``.
    /// Ensure that your standard conforms to all protocols enforced by the ``Component``s. If your ``Component``s require protocol conformances
    /// you must add them to your custom type conforming to ``Standard`` and passed to the initializer or extend a prebuild standard.
    ///
    /// - Parameters:
    ///   - components: The ``Component``s used in the Spezi project. You can define the ``Component``s using the ``ComponentBuilder`` result builder.
    public init(
        @ComponentBuilder _ components: () -> (ComponentCollection)
    ) {
        self.spezi = Spezi<DefaultStandard>(standard: DefaultStandard(), components: components().elements)
    }
}
