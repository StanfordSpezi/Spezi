//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


#if os(iOS) || os(visionOS)
typealias ApplicationDelegate = UIApplicationDelegate & UISceneDelegate
/// Platform agnostic ApplicationDelegateAdaptor.
///
/// Type-alias for the `UIApplicationDelegateAdaptor`.
public typealias ApplicationDelegateAdaptor = UIApplicationDelegateAdaptor
#elseif os(macOS)
typealias ApplicationDelegate = NSApplicationDelegate
/// Platform agnostic ApplicationDelegateAdaptor.
///
/// Type-alias for the `NSApplicationDelegateAdaptor`.
public typealias ApplicationDelegateAdaptor = NSApplicationDelegateAdaptor
#elseif os(watchOS)
typealias ApplicationDelegate = WKApplicationDelegate
/// Platform agnostic ApplicationDelegateAdaptor.
///
/// Type-alias for the `WKApplicationDelegateAdaptor`.
public typealias ApplicationDelegateAdaptor = WKApplicationDelegateAdaptor
#endif



/// Configure the Spezi-based application using the ``SpeziAppDelegate/configuration`` property.
///
/// Set up the Spezi framework in your `App` instance of your SwiftUI application using the ``SpeziAppDelegate`` and the `@ApplicationDelegateAdaptor` property wrapper.
/// Use the `View.spezi(_: SpeziAppDelegate)` view modifier to apply your Spezi configuration to the main view in your SwiftUI `Scene`:
/// ```swift
/// import Spezi
/// import SwiftUI
///
///
/// @main
/// struct ExampleApp: App {
///     @ApplicationDelegateAdaptor(SpeziAppDelegate.self) var appDelegate
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
open class SpeziAppDelegate: NSObject, ApplicationDelegate {
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

#if os(iOS) || os(visionOS) || os(tvOS)
    open func application(
        _ application: UIApplication,
        // The usage of an optional collection is impossible to avoid as the function signature is defined by the `UIApplicationDelegate`
        // swiftlint:disable:next discouraged_optional_collection
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        if !ProcessInfo.processInfo.isPreviewSimulator {
            // If you are running an Xcode Preview and you have your global SwiftUI `App` defined with
            // the `@UIApplicationDelegateAdaptor` property wrapper, it will still instantiate the App Delegate
            // and call this willFinishLaunchingWithOptions delegate method. This results in an instantiation of Spezi
            // and configuration of the respective modules. This might and will cause troubles with Modules that
            // are only meant to be instantiated once. Therefore, we skip execution of this if running inside the PreviewSimulator.
            // This is also not a problem, as there is no way to set up an application delegate within a Xcode preview.
            spezi.willFinishLaunchingWithOptions(launchOptions: launchOptions ?? [:])
        }
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

    open func applicationWillTerminate(_ application: UIApplication) {
        spezi.applicationWillTerminate()
    }

    open func sceneWillEnterForeground(_ scene: UIScene) {
        spezi.sceneWillEnterForeground()
    }
    
    open func sceneDidBecomeActive(_ scene: UIScene) {
        spezi.sceneDidBecomeActive()
    }
    
    open func sceneWillResignActive(_ scene: UIScene) {
        spezi.sceneWillResignActive()
    }
    
    open func sceneDidEnterBackground(_ scene: UIScene) {
        spezi.sceneDidEnterBackground()
    }
#elseif os(macOS)
    open func applicationWillFinishLaunching(_ notification: Notification) {
        if !ProcessInfo.processInfo.isPreviewSimulator {
            spezi.willFinishLaunchingWithOptions(launchOptions: [:])
        }
    }

    open func applicationWillTerminate(_ notification: Notification) {
        spezi.applicationWillTerminate()
    }

    open func applicationWillBecomeActive(_ notification: Notification) {
        spezi.sceneWillEnterForeground() // TODO: is that accurate?
    }

    open func applicationDidBecomeActive(_ notification: Notification) {
        spezi.sceneDidBecomeActive()
    }

    open func applicationWillResignActive(_ notification: Notification) {
        spezi.sceneWillResignActive()
    }

    open func applicationDidResignActive(_ notification: Notification) {
        spezi.sceneDidEnterBackground()
    }
#elseif os(watchOS)
    open func applicationDidFinishLaunching() {
        if !ProcessInfo.processInfo.isPreviewSimulator {
            spezi.willFinishLaunchingWithOptions(launchOptions: [:])
        }
    }

    // applicationWillTerminate(_:) not supported for WatchKit

    open func applicationWillEnterForeground() {
        spezi.sceneWillEnterForeground()
    }

    open func applicationDidBecomeActive() {
        spezi.sceneDidBecomeActive()
    }

    open func applicationWillResignActive() {
        spezi.sceneWillResignActive()
    }

    open func applicationDidEnterBackground() {
        spezi.sceneDidEnterBackground()
    }
#endif
}
