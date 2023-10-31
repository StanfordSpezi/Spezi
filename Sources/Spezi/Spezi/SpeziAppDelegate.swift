//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Configure the Spezi-based application using the ``SpeziAppDelegate/configuration`` property.
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
/// Register your different ``Module``s (or more sophisticated ``Module``s) using the ``SpeziAppDelegate/configuration`` property.
/// ```swift
/// import Spezi
///
///
/// class TemplateAppDelegate: SpeziAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: ExampleStandard()) {
///             // Add your `Module`s here ...
///        }
///     }
/// }
/// ```
///
/// The ``Module`` documentation provides more information about the structure of modules.
/// Refer to the ``Configuration`` documentation to learn more about the Spezi configuration.
open class SpeziAppDelegate: NSObject, UIApplicationDelegate, UISceneDelegate {
    private(set) static weak var appDelegate: SpeziAppDelegate?
    
    
    private(set) lazy var spezi: AnySpezi = configuration.spezi
    
    
    /// Register your different ``Module``s (or more sophisticated ``Module``s) using the ``SpeziAppDelegate/configuration`` property,.
    ///
    /// The ``Standard`` acts as a central message broker in the application.
    /// ```swift
    /// import Spezi
    ///
    ///
    /// class TemplateAppDelegate: SpeziAppDelegate {
    ///     override var configuration: Configuration {
    ///         Configuration(standard: ExampleStandard()) {
    ///             // Add your `Module`s here ...
    ///        }
    ///     }
    /// }
    /// ```
    ///
    /// The ``Module`` documentation provides more information about the structure of modules.
    /// Refer to the ``Configuration`` documentation to learn more about the Spezi configuration.
    open var configuration: Configuration {
        Configuration { }
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
        SpeziAppDelegate.appDelegate = self
        sceneConfig.delegateClass = SpeziSceneDelegate.self
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
