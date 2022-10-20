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
public protocol LifecycleHandler {
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    )
    
    func applicationWillTerminate(
        _ application: UIApplication
    )
}


extension LifecycleHandler {
    public func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) { }
    
    public func applicationWillTerminate(
        _ application: UIApplication
    ) { }
}


extension Array: LifecycleHandler where Element == LifecycleHandler {
    public func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) {
        for lifecycleHandler in self {
            lifecycleHandler.willFinishLaunchingWithOptions(application, launchOptions: launchOptions)
        }
    }
    
    public func applicationWillTerminate(
        _ application: UIApplication
    ) {
        for lifecycleHandler in self {
            lifecycleHandler.applicationWillTerminate(application)
        }
    }
}
