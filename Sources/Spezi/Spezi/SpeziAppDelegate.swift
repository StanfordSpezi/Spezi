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

    private var _spezi: Spezi?

    var spezi: Spezi {
        guard let spezi = _spezi else {
            let spezi = Spezi(from: configuration)
            self._spezi = spezi
            return spezi
        }
        return spezi
    }
    
    
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
    @available(*, deprecated, message: "Propagate deprecation warning.")
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

            precondition(_spezi == nil, "\(#function) was called when Spezi was already initialized. Unable to pass options!")

            var storage = SpeziStorage()
            storage[LaunchOptionsKey.self] = launchOptions
            self._spezi = Spezi(from: configuration, storage: storage)

            // backwards compatibility
            spezi.lifecycleHandler.willFinishLaunchingWithOptions(application, launchOptions: launchOptions ?? [:])
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

    @available(*, deprecated, message: "Propagate deprecation warning.")
    open func applicationWillTerminate(_ application: UIApplication) {
        spezi.lifecycleHandler.applicationWillTerminate(application)
    }

    @available(*, deprecated, message: "Propagate deprecation warning.")
    open func sceneWillEnterForeground(_ scene: UIScene) {
        spezi.lifecycleHandler.sceneWillEnterForeground(scene)
    }
    
    @available(*, deprecated, message: "Propagate deprecation warning.")
    open func sceneDidBecomeActive(_ scene: UIScene) {
        spezi.lifecycleHandler.sceneDidBecomeActive(scene)
    }
    
    @available(*, deprecated, message: "Propagate deprecation warning.")
    open func sceneWillResignActive(_ scene: UIScene) {
        spezi.lifecycleHandler.sceneWillResignActive(scene)
    }
    
    @available(*, deprecated, message: "Propagate deprecation warning.")
    open func sceneDidEnterBackground(_ scene: UIScene) {
        spezi.lifecycleHandler.sceneDidEnterBackground(scene)
    }
#elseif os(macOS)
    open func applicationWillFinishLaunching(_ notification: Notification) {
        if !ProcessInfo.processInfo.isPreviewSimulator {
            // see note above for why we don't launch this within the preview simulator!

            precondition(_spezi == nil, "\(#function) was called when Spezi was already initialized. Unable to pass options!")

            var storage = SpeziStorage()
            storage[LaunchOptionsKey.self] = notification.userInfo
            self._spezi = Spezi(from: configuration, storage: storage)
        }
    }
#endif
}
