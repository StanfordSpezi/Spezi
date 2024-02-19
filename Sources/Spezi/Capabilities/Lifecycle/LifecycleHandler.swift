//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SwiftUI


/// Delegate methods are related to the  `UIApplication` and ``Spezi/Spezi`` lifecycle.
///
/// Conform to the `LifecycleHandler` protocol to get updates about the application lifecycle similar to the `UIApplicationDelegate` on an app basis.
///
/// You can, e.g., implement the following functions to get informed about the application launching and being terminated:
/// - ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp``
/// - ``LifecycleHandler/applicationWillTerminate(_:)-35fxv``
///
/// All methods supported by the module capability are listed blow.
@available(
    *,
    deprecated,
    message: """
             Please use the new @Application property wrapper to access delegate functionality. \
             Otherwise use the SwiftUI onReceive(_:perform:) for UI related notifications.
             """
)
public protocol LifecycleHandler {
#if os(iOS) || os(visionOS) || os(tvOS)
    /// Replicates  the `application(_: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool`
    /// functionality of the `UIApplicationDelegate`.
    ///
    /// Tells the delegate that the launch process has begun but that state restoration hasn't occurred.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - launchOptions: A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly. For information about the possible keys in this dictionary and how to handle them, see UIApplication.LaunchOptionsKey.
    @available(
        *,
        deprecated,
        message: """
                 Please use the new @Application(\\.launchOptions) property wrapper within your Module \
                 to access launchOptions in a platform independent way.
                 """
    )
    func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any])

    /// Replicates  the `sceneWillEnterForeground(_: UIScene)` functionality of the `UISceneDelegate`.
    ///
    /// Tells the delegate that the scene is about to begin running in the foreground and become visible to the user.
    ///
    /// - Important: This method is deprecated. This method is only called on iOS and not supported on other platforms.
    ///
    ///
    /// - Parameter scene: The scene that is about to enter the foreground.
    @available(
        *,
        deprecated,
        message: """
                 Using UISceneDelegate is deprecated. \
                 Use the SwiftUI ScenePhase environment property or the UIScene.willEnterForegroundNotification publisher on iOS \
                 or other platform-specific mechanisms as a replacement.
                 """
    )
    func sceneWillEnterForeground(_ scene: UIScene)

    /// Replicates  the `sceneDidBecomeActive(_: UIScene)` functionality of the `UISceneDelegate`.
    ///
    /// Tells the delegate that the scene became active and is now responding to user events.
    /// - Parameter scene: The scene that became active and is now responding to user events.
    @available(
        *,
         deprecated,
         message: """
                  Using UISceneDelegate is deprecated. \
                  Use the SwiftUI ScenePhase environment property or the UIScene.didActivateNotification publisher on iOS \
                  or other platform-specific mechanisms as a replacement.
                  """
    )
    func sceneDidBecomeActive(_ scene: UIScene)

    /// Replicates  the `sceneWillResignActive(_: UIScene)` functionality of the `UISceneDelegate`.
    ///
    /// Tells the delegate that the scene is about to resign the active state and stop responding to user events.
    /// - Parameter scene: The scene that is about to stop responding to user events.
    @available(
        *,
         deprecated,
         message: """
                  Using UISceneDelegate is deprecated. \
                  Use the SwiftUI ScenePhase environment property or the UIScene.willDeactivateNotification publisher on iOS \
                  or other platform-specific mechanisms as a replacement.
                  """
    )
    func sceneWillResignActive(_ scene: UIScene)

    /// Replicates  the `sceneDidEnterBackground(_: UIScene)` functionality of the `UISceneDelegate`.
    ///
    /// Tells the delegate that the scene is running in the background and is no longer onscreen.
    /// - Parameter scene: The scene that entered the background.
    @available(
        *,
         deprecated,
         message: """
                  Using UISceneDelegate is deprecated. \
                  Use the SwiftUI ScenePhase environment property or the UIScene.didEnterBackgroundNotification publisher on iOS \
                  or other platform-specific mechanisms as a replacement.
                  """
    )
    func sceneDidEnterBackground(_ scene: UIScene)

    /// Replicates  the `applicationWillTerminate(_: UIApplication)` functionality of the `UIApplicationDelegate`.
    ///
    /// Tells the delegate when the app is about to terminate.
    /// - Parameter application: Your singleton app object.
    @available(
        *,
        deprecated,
        message: """
                 Using UISceneDelegate is deprecated. \
                 Use the SwiftUI onReceive(_:perform:) modifier with the UIApplication.willTerminateNotification publisher on iOS \
                 or other platform-specific mechanisms as a replacement.
                 """
    )
    func applicationWillTerminate(_ application: UIApplication)
#endif
}


@available(
    *,
     deprecated,
     message: """
             Please use the new @Application property wrapper to access delegate functionality. \
             Otherwise use the SwiftUI onReceive(_:perform:) for UI related notifications.
             """
)
extension LifecycleHandler {
#if os(iOS) || os(visionOS) || os(tvOS)
    // A documentation for this method exists in the `LifecycleHandler` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]) {}

    // A documentation for this method exists in the `LifecycleHandler` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func sceneWillEnterForeground(_ scene: UIScene) { }

    // A documentation for this method exists in the `LifecycleHandler` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func sceneDidBecomeActive(_ scene: UIScene) { }

    // A documentation for this method exists in the `LifecycleHandler` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func sceneWillResignActive(_ scene: UIScene) { }

    // A documentation for this method exists in the `LifecycleHandler` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func sceneDidEnterBackground(_ scene: UIScene) { }

    // A documentation for this method exists in the `LifecycleHandler` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func applicationWillTerminate(_ application: UIApplication) { }
#endif
}


@available(
    *,
     deprecated,
     message: """
              Please use the new @Application property wrapper to access delegate functionality. \
              Otherwise use the SwiftUI onReceive(_:perform:) for UI related notifications.
              """
)
extension Array: LifecycleHandler where Element == LifecycleHandler {
#if os(iOS) || os(visionOS) || os(tvOS)
    @available(
        *,
        deprecated,
        message: """
                 Please use the new @Application(\\.launchOptions) property wrapper within your Module \
                 to access launchOptions in a platform independent way.
                 """
    )
    public func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
        for lifecycleHandler in self {
            lifecycleHandler.willFinishLaunchingWithOptions(application, launchOptions: launchOptions)
        }
    }

    @available(
        *,
         deprecated,
         message: """
                  Using UISceneDelegate is deprecated. \
                  Use the SwiftUI ScenePhase environment property or the UIScene.willEnterForegroundNotification publisher on iOS \
                  or other platform-specific mechanisms as a replacement.
                  """
    )
    public func sceneWillEnterForeground(_ scene: UIScene) {
        for lifecycleHandler in self {
            lifecycleHandler.sceneWillEnterForeground(scene)
        }
    }
    
    @available(
        *,
         deprecated,
         message: """
                  Using UISceneDelegate is deprecated. \
                  Use the SwiftUI ScenePhase environment property or the UIScene.didActivateNotification publisher on iOS \
                  or other platform-specific mechanisms as a replacement.
                  """
    )
    public func sceneDidBecomeActive(_ scene: UIScene) {
        for lifecycleHandler in self {
            lifecycleHandler.sceneDidBecomeActive(scene)
        }
    }
    
    @available(
        *,
         deprecated,
         message: """
                  Using UISceneDelegate is deprecated. \
                  Use the SwiftUI ScenePhase environment property or the UIScene.willDeactivateNotification publisher on iOS \
                  or other platform-specific mechanisms as a replacement.
                  """
    )
    public func sceneWillResignActive(_ scene: UIScene) {
        for lifecycleHandler in self {
            lifecycleHandler.sceneWillResignActive(scene)
        }
    }
    
    @available(
        *,
         deprecated,
         message: """
                  Using UISceneDelegate is deprecated. \
                  Use the SwiftUI ScenePhase environment property or the UIScene.didEnterBackgroundNotification publisher on iOS \
                  or other platform-specific mechanisms as a replacement.
                  """
    )
    public func sceneDidEnterBackground(_ scene: UIScene) {
        for lifecycleHandler in self {
            lifecycleHandler.sceneDidEnterBackground(scene)
        }
    }

    @available(
        *,
        deprecated,
        message: """
                 Using UISceneDelegate is deprecated. \
                 Use the SwiftUI onReceive(_:perform:) modifier with the UIApplication.willTerminateNotification publisher on iOS \
                 or other platform-specific mechanisms as a replacement.
                 """
    )
    public func applicationWillTerminate(_ application: UIApplication) {
        for lifecycleHandler in self {
            lifecycleHandler.applicationWillTerminate(application)
        }
    }
#endif
}
