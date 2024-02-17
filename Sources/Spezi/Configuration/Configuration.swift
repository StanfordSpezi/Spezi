//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Defines the ``Standard`` and ``Module``s that are used in a Spezi project.
///
/// Ensure that your standard conforms to all protocols enforced by the ``Module``s. If your ``Module``s require protocol conformances
/// you must add them to your custom type conforming to ``Standard`` and passed to the initializer or extend a prebuilt standard.
///
/// Use ``Configuration/init(_:)`` to use default empty standard instance only conforming to ``Standard`` if you do not use any ``Module`` requiring custom protocol conformances.
///
///
/// The following example demonstrates the usage of an `ExampleStandard` standard and reusable Spezi modules, including the `HealthKit` and `QuestionnaireDataSource` modules:
/// ```swift
/// import Spezi
/// import SpeziHealthKit
/// import SpeziOnboarding
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
///             OnboardingDataSource()
///         }
///     }
/// }
/// ```
///
/// The ``Module`` documentation provides more information about the structure of modules.
///
/// ## Topics
///
/// ### Result Builder
/// - ``ModuleBuilder``
/// - ``ModuleCollection``
public struct Configuration {
    let standard: any Standard
    let modules: ModuleCollection
    

    /// A ``Configuration`` defines the ``Standard`` and ``Module``s that are used in a Spezi project.
    ///
    /// Ensure that your standard conforms to all protocols enforced by the ``Module``s. If your ``Module``s require protocol conformances
    /// you must add them to your custom type conforming to ``Standard`` and passed to the initializer or extend a prebuild standard.
    ///
    /// Use ``Configuration/init(_:)`` to use default empty standard instance only conforming to ``Standard`` if you do not use any ``Module`` requiring custom protocol conformances.
    /// - Parameters:
    ///   - standard: The global ``Standard`` used throughout the app to manage global data flow.
    ///   - modules: The ``Module``s used in the Spezi project. You can define the ``Module``s using the ``ModuleBuilder`` result builder.
    public init<S: Standard>(
        standard: S,
        @ModuleBuilder _ modules: () -> ModuleCollection
    ) {
        self.standard = standard
        self.modules = modules()
    }
    
    
    /// A ``Configuration`` defines the ``Standard`` and ``Module``s that are used in a Spezi project.
    ///
    /// This initializer creates a default empty standard instance only conforming to ``Standard``.
    /// Use ``Configuration/init(standard:_:)`` to provide a custom ``Standard`` instance if you use any ``Module`` requiring custom protocol conformances.
    ///
    /// - Parameters:
    ///   - modules: The ``Module``s used in the Spezi project. You can define the ``Module``s using the ``ModuleBuilder`` result builder.
    public init(
        @ModuleBuilder _ modules: () -> ModuleCollection
    ) {
        self.init(standard: DefaultStandard(), modules)
    }
}
