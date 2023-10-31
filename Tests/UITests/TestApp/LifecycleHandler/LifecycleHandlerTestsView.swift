//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import XCTestApp
import XCTSpezi


struct LifecycleHandlerTestsView: View {
    @Environment(LifecycleHandlerModel.self)
    var model
    
    
    var body: some View {
        VStack {
            Text("WillFinishLaunchingWithOptions: \(model.willFinishLaunchingWithOptions)")
            Text("SceneWillEnterForeground: \(model.sceneWillEnterForeground)")
            Text("SceneDidBecomeActive: \(model.sceneDidBecomeActive)")
            Text("SceneWillResignActive: \(model.sceneWillResignActive)")
            Text("SceneDidEnterBackground: \(model.sceneDidEnterBackground)")
            Text("ApplicationWillTerminate: \(model.applicationWillTerminate)")
        }
    }
}
