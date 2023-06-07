//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SwiftUI


extension AnySpezi {
    /// A collection of ``Spezi/Spezi`` `LifecycleHandler`s.
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
    
    func applicationDidBecomeActive(
        _ application: UIApplication
    ) {
        lifecycleHandler.applicationDidBecomeActive(application)
    }
    
    func applicationWillResignActive(
        _ application: UIApplication
    ) {
        lifecycleHandler.applicationWillResignActive(application)
    }
    
    func applicationDidEnterBackground(
        _ application: UIApplication
    ) {
        lifecycleHandler.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(
        _ application: UIApplication
    ) {
        lifecycleHandler.applicationWillEnterForeground(application)
    }
    
    func applicationWillTerminate(
        _ application: UIApplication
    ) {
        lifecycleHandler.applicationWillTerminate(application)
    }
}
