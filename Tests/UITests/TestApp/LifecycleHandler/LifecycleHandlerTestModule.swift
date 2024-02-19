//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI


@Observable
class LifecycleHandlerModel {
    var willFinishLaunchingWithOptions: Int = 0
    var sceneWillEnterForeground: Int = 0
    var sceneDidBecomeActive: Int = 0
    var sceneWillResignActive: Int = 0
    var sceneDidEnterBackground: Int = 0
    var applicationWillTerminate: Int = 0

    func reset() {
        willFinishLaunchingWithOptions = 0
        sceneWillEnterForeground = 0
        sceneDidBecomeActive = 0
        sceneWillResignActive = 0
        sceneDidEnterBackground = 0
        applicationWillTerminate = 0
    }
}


struct LifecycleHandlerModifier: ViewModifier {
    @State var model: LifecycleHandlerModel
    
    init(model: LifecycleHandlerModel) {
        self.model = model
    }
    
    func body(content: Content) -> some View {
        content.environment(model)
    }
}


final class LifecycleHandlerTestModule: Module, LifecycleHandler {
    private let model: LifecycleHandlerModel

    @Modifier var modifier: LifecycleHandlerModifier

    init() {
        let model = LifecycleHandlerModel()
        self.model = model
        self.modifier = LifecycleHandlerModifier(model: model)
    }

#if os(iOS) || os(visionOS) || os(tvOS)
    func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
        model.reset() // avoids the need to delete the app.
        model.willFinishLaunchingWithOptions += 1
        precondition(model.willFinishLaunchingWithOptions - 1 == model.applicationWillTerminate)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        model.sceneWillEnterForeground += 1
        #if !os(visionOS)
        precondition(model.sceneWillEnterForeground - 1 == model.sceneDidBecomeActive)
        #endif
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        model.sceneDidBecomeActive += 1
        #if !os(visionOS)
        precondition(model.sceneWillEnterForeground == model.sceneDidBecomeActive)
        #endif
    }

    func sceneWillResignActive(_ scene: UIScene) {
        model.sceneWillResignActive += 1
        // on visionOS an app might resign active without entering the background (and become active again after that).
        #if !os(visionOS)
        precondition(model.sceneWillResignActive - 1 == model.sceneDidEnterBackground)
        #endif
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        model.sceneDidEnterBackground += 1
        #if !os(visionOS)
        precondition(model.sceneWillResignActive == model.sceneDidEnterBackground)
        #endif
    }

    func applicationWillTerminate(_ application: UIApplication) {
        model.applicationWillTerminate += 1
        #if !os(visionOS)
        precondition(model.willFinishLaunchingWithOptions == model.applicationWillTerminate)
        #endif
    }
#endif
}
