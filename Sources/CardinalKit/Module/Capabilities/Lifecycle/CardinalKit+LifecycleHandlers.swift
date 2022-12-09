//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SwiftUI


extension AnyCardinalKit {
    /// A collection of ``CardinalKit/CardinalKit`` `LifecycleHandler`s.
    private var lifecycleHandler: [LifecycleHandler] {
        typedCollection.get(allThatConformTo: LifecycleHandler.self)
    }
    
    
    // MARK: LifecycleHandler Functions
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) {
        lifecycleHandler.willFinishLaunchingWithOptions(application, launchOptions: launchOptions)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        lifecycleHandler.applicationWillTerminate(application)
    }
}
