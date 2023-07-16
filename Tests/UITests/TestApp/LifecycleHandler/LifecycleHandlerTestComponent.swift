//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI


final class LifecycleHandlerTestComponent: Module {
    @AppStorage("willFinishLaunchingWithOptions") var willFinishLaunchingWithOptions: Int = 0
    @AppStorage("sceneWillEnterForeground") var sceneWillEnterForeground: Int = 0
    @AppStorage("sceneDidBecomeActive") var sceneDidBecomeActive: Int = 0
    @AppStorage("sceneWillResignActive") var sceneWillResignActive: Int = 0
    @AppStorage("sceneDidEnterBackground") var sceneDidEnterBackground: Int = 0
    @AppStorage("applicationWillTerminate") var applicationWillTerminate: Int = 0
    
    
    func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
        willFinishLaunchingWithOptions += 1
        precondition(willFinishLaunchingWithOptions - 1 == applicationWillTerminate)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        sceneWillEnterForeground += 1
        precondition(sceneWillEnterForeground - 1 == sceneDidBecomeActive)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        sceneDidBecomeActive += 1
        precondition(sceneWillEnterForeground == sceneDidBecomeActive)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        sceneWillResignActive += 1
        precondition(sceneWillResignActive - 1 == sceneDidEnterBackground)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        sceneDidEnterBackground += 1
        precondition(sceneWillResignActive == sceneDidEnterBackground)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        applicationWillTerminate += 1
        precondition(willFinishLaunchingWithOptions == applicationWillTerminate)
    }
}
