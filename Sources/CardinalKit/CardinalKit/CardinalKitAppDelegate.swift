//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// The ``CardinalKitAppDelegate`` is used to configure the CardinalKit-based application using the ``CardinalKitAppDelegate/configuration`` property.
///
/// Set up the CardinalKit framework in your `App` instance of your SwiftUI application using the ``CardinalKitAppDelegate`` and the `@UIApplicationDelegateAdaptor` property wrapper.
/// Use the `View.cardinalKit(_: CardinalKitAppDelegate)` view modifier to apply your CardinalKit configuration to the main view in your SwiftUI `Scene`:
/// ```swift
/// import CardinalKit
/// import SwiftUI
///
///
/// @main
/// struct ExampleApp: App {
///     @UIApplicationDelegateAdaptor(CardinalKitAppDelegate.self) var appDelegate
///
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .cardinalKit(appDelegate)
///         }
///     }
/// }
/// ```
///
/// Register your different ``Component``s (or more sophisticated ``Module``s) using the ``CardinalKitAppDelegate/configuration`` property, e.g., using the
/// `FHIR` standard integrated into the CardinalKit framework:
/// ```swift
/// import CardinalKit
/// import FHIR
///
///
/// class TemplateAppDelegate: CardinalKitAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: FHIR()) {
///             // Add your `Component`s here ...
///        }
///     }
/// }
/// ```
///
/// The ``Component`` documentation provides more information about the structure of components.
/// Refer to the ``Configuration`` documentation to learn more about the CardinalKit configuration.
open class CardinalKitAppDelegate: NSObject, UIApplicationDelegate {
    private actor DefaultStandard: Standard {
        typealias BaseType = StandardType
        typealias RemovalContext = BaseType
        
        
        struct StandardType: Identifiable {
            var id: UUID
        }
        
        
        func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>) { }
    }
    
    
    private(set) lazy var cardinalKit: AnyCardinalKit = configuration.cardinalKit
    
    
    /// Register your different ``Component``s (or more sophisticated ``Module``s) using the ``CardinalKitAppDelegate/configuration`` property, e.g., using the
    /// `FHIR` standard integrated into the CardinalKit framework:
    /// ```swift
    /// import CardinalKit
    /// import FHIR
    ///
    ///
    /// class TemplateAppDelegate: CardinalKitAppDelegate {
    ///     override var configuration: Configuration {
    ///         Configuration(standard: FHIR()) {
    ///             // Add your `Component`s here ...
    ///        }
    ///     }
    /// }
    /// ```
    ///
    /// The ``Component`` documentation provides more information about the structure of components.
    /// Refer to the ``Configuration`` documentation to learn more about the CardinalKit configuration.
    open var configuration: Configuration {
        Configuration(standard: DefaultStandard()) { }
    }
    
    
    open func application(
        _ application: UIApplication,
        // The usage of an optional collection is impossible to avoid as the function signature is defined by the `UIApplicationDelegate`
        // swiftlint:disable:next discouraged_optional_collection
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        cardinalKit.willFinishLaunchingWithOptions(application, launchOptions: launchOptions ?? [:])
        return true
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        cardinalKit.applicationWillTerminate(application)
    }
}
