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
    var configuration: _Configuration {
        _Configuration(standard: AnyStandard()) {
            EmptyConfiguration<AnyStandard>()
        }
    }
    
    public func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        configuration.anyCardinalKit.willFinishLaunchingWithOptions(application, launchOptions: launchOptions ?? [:])
        return true
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        configuration.anyCardinalKit.applicationWillTerminate(application)
    }
}

struct AnyStandard: Standard {}


struct _Configuration {
    let anyCardinalKit: AnyCardinalKit
    
    
    init<S: Standard>(
        standard: S,
        @ConfigurationBuilder<S> _ configuration: () -> (Configuration)
    ) {
        self.anyCardinalKit = CardinalKit<S>(configuration: configuration())
    }
}
