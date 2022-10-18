//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SwiftUI


extension Array<LifecycleHandler>: StorageKey {}


extension CardinalKit: LifecycleHandler {
    /// A collection of ``CardinalKit/CardinalKit`` `LifecycleHandler`s.
    var handlers: [LifecycleHandler] {
        get async {
            await storage.get(allThatConformTo: LifecycleHandler.self)
        }
    }
    
    
    // MARK: LifecycleHandler Functions
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any],
        cardinalKit: CardinalKit
    ) {
        Task(priority: .userInitiated) {
            await handlers.willFinishLaunchingWithOptions(application, launchOptions: launchOptions, cardinalKit: cardinalKit)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication, cardinalKit: CardinalKit) {
        Task(priority: .userInitiated) {
            await handlers.applicationWillTerminate(application, cardinalKit: cardinalKit)
        }
    }
}
