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
    var lifecycleHandler: [LifecycleHandler] {
        storage.collect(allOf: LifecycleHandler.self)
    }
    
    
    // MARK: LifecycleHandler Functions
    func willFinishLaunchingWithOptions(
        launchOptions: [LaunchOptionsKey: Any]
    ) {
        lifecycleHandler.willFinishLaunchingWithOptions(launchOptions: launchOptions)
    }
    
    func sceneWillEnterForeground() {
        lifecycleHandler.sceneWillEnterForeground()
    }
    
    func sceneDidBecomeActive() {
        lifecycleHandler.sceneDidBecomeActive()
    }
    
    func sceneWillResignActive() {
        lifecycleHandler.sceneWillResignActive()
    }
    
    func sceneDidEnterBackground() {
        lifecycleHandler.sceneDidEnterBackground()
    }
    
    func applicationWillTerminate() {
        lifecycleHandler.applicationWillTerminate()
    }
}
