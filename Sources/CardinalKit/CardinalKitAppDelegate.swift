//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// The `CardinalKitAppDelegate` is used to configure the CardinalKit-based application using the ``CardinalKitAppDelegate/configuration`` property.
///
/// Set up the CardinalKit framework in your `App` instance of your SwiftUI applicaton using the ``CardinalKitAppDelegate`` and the `@UIApplicationDelegateAdaptor` property wrapper.
/// Use the ``SwiftUI/View/.cardinalKit(_: CardinalKitAppDelegate)`` view modifier to apply your CardinalKit configuration to the main view in your SwiftUI `Scene`:
/// ```
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
public class CardinalKitAppDelegate: NSObject, UIApplicationDelegate {
    lazy var cardinalKit: CardinalKit = {
        CardinalKit(configuration: configuration)
    }()
    
    
    /// The configuration of the CardinalKit framework.
    ///
    /// Use this configuration to define your different modules used in your CardinalKit-based application.
    @ConfigurationBuilder
    public var configuration: Configuration {
        EmptyConfiguration()
    }
    
    
    public func application(
        _ application: UIApplication,
        // swiftlint:disable:next discouraged_optional_collection
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        cardinalKit.willFinishLaunchingWithOptions(application, launchOptions: launchOptions ?? [:], cardinalKit: cardinalKit)
        return true
    }
    
    
    public func applicationWillTerminate(_ application: UIApplication) {
        cardinalKit.applicationWillTerminate(application, cardinalKit: cardinalKit)
    }
}
