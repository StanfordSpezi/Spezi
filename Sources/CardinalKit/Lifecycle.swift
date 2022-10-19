//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SwiftUI


/// Delegate methods related to the  ``UIApplication`` and ``CardinalKit/CardinalKit`` lifecycle
protocol LifecycleHandler {
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    )
    
    func applicationWillTerminate(
        _ application: UIApplication
    )
}


extension LifecycleHandler {
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) { }
    
    func applicationWillTerminate(
        _ application: UIApplication
    ) { }
}


extension Array: LifecycleHandler where Element == LifecycleHandler {
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) {
        for lifecycleHandler in self {
            lifecycleHandler.willFinishLaunchingWithOptions(application, launchOptions: launchOptions)
        }
    }
    
    func applicationWillTerminate(
        _ application: UIApplication
    ) {
        for lifecycleHandler in self {
            lifecycleHandler.applicationWillTerminate(application)
        }
    }
}
