//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SwiftUI


/// Open-source framework for rapid development of modern, interoperable digital health applications.
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
protocol AnyCardinalKit {
    /// A typesafe storage of different elements of an ``CardinalKit/CardinalKit`` instance.
    var storage: Storage { get }
    /// Logger used to log events in the ``CardinalKit/CardinalKit`` instance.
    var logger: Logger { get }
}


public class CardinalKit<S: Standard>: AnyCardinalKit, ObservableObject {
    /// A typesafe storage of different elements of an ``CardinalKit/CardinalKit`` instance.
    public let storage: Storage
    /// Logger used to log events in the ``CardinalKit/CardinalKit`` instance.
    public let logger: Logger
    
    
    /// Creates a new instance of the CardinalKit manager
    init(
        configuration: _AnyComponent,
        _ logger: Logger = Logger(subsystem: "edu.stanford.cardinalkit", category: "cardinalkit")
    ) {
        self.logger = logger
        self.storage = Storage(logger: logger)
        
        configuration.configureAny(cardinalKit: self)
    }
}
