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
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) {
        lifecycleHandler.willFinishLaunchingWithOptions(application, launchOptions: launchOptions)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        lifecycleHandler.sceneWillEnterForeground(scene)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        lifecycleHandler.sceneDidBecomeActive(scene)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        lifecycleHandler.sceneWillResignActive(scene)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        lifecycleHandler.sceneDidEnterBackground(scene)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        lifecycleHandler.applicationWillTerminate(application)
    }
}
