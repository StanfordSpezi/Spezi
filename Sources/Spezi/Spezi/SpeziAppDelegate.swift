//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// The ``SpeziAppDelegate`` is used to configure the Spezi-based application using the ``SpeziAppDelegate/configuration`` property.
///
/// Set up the Spezi framework in your `App` instance of your SwiftUI application using the ``SpeziAppDelegate`` and the `@UIApplicationDelegateAdaptor` property wrapper.
/// Use the `View.spezi(_: SpeziAppDelegate)` view modifier to apply your Spezi configuration to the main view in your SwiftUI `Scene`:
/// ```swift
/// import Spezi
/// import SwiftUI
///
///
/// @main
/// struct ExampleApp: App {
///     @UIApplicationDelegateAdaptor(SpeziAppDelegate.self) var appDelegate
///
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .spezi(appDelegate)
///         }
///     }
/// }
/// ```
///
/// Register your different ``Component``s (or more sophisticated ``Module``s) using the ``SpeziAppDelegate/configuration`` property, e.g., using the
/// `FHIR` standard integrated into the Spezi framework:
/// ```swift
/// import Spezi
/// import FHIR
///
///
/// class TemplateAppDelegate: SpeziAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: FHIR()) {
///             // Add your `Component`s here ...
///        }
///     }
/// }
/// ```
///
/// The ``Component`` documentation provides more information about the structure of components.
/// Refer to the ``Configuration`` documentation to learn more about the Spezi configuration.
open class SpeziAppDelegate: NSObject, UIApplicationDelegate, UISceneDelegate {
    private actor DefaultStandard: Standard {
        typealias BaseType = StandardType
        typealias RemovalContext = BaseType
        
        
        struct StandardType: Identifiable {
            var id: UUID
        }
        
        
        func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>) { }
    }
    
    
    private(set) lazy var spezi: AnySpezi = configuration.spezi
    
    
    /// Register your different ``Component``s (or more sophisticated ``Module``s) using the ``SpeziAppDelegate/configuration`` property, e.g., using the
    /// `FHIR` standard integrated into the Spezi framework:
    /// ```swift
    /// import Spezi
    /// import FHIR
    ///
    ///
    /// class TemplateAppDelegate: SpeziAppDelegate {
    ///     override var configuration: Configuration {
    ///         Configuration(standard: FHIR()) {
    ///             // Add your `Component`s here ...
    ///        }
    ///     }
    /// }
    /// ```
    ///
    /// The ``Component`` documentation provides more information about the structure of components.
    /// Refer to the ``Configuration`` documentation to learn more about the Spezi configuration.
    open var configuration: Configuration {
        Configuration(standard: DefaultStandard()) { }
    }
    
    
    open func application(
        _ application: UIApplication,
        // The usage of an optional collection is impossible to avoid as the function signature is defined by the `UIApplicationDelegate`
        // swiftlint:disable:next discouraged_optional_collection
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        spezi.willFinishLaunchingWithOptions(application, launchOptions: launchOptions ?? [:])
        return true
    }
    
    open func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = Self.self
        return sceneConfig
    }
    
    open func sceneWillEnterForeground(_ scene: UIScene) {
        spezi.sceneWillEnterForeground(scene)
    }
    
    open func sceneDidBecomeActive(_ scene: UIScene) {
        spezi.sceneDidBecomeActive(scene)
    }
    
    open func sceneWillResignActive(_ scene: UIScene) {
        spezi.sceneWillResignActive(scene)
    }
    
    open func sceneDidEnterBackground(_ scene: UIScene) {
        spezi.sceneDidEnterBackground(scene)
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        spezi.applicationWillTerminate(application)
    }
}
