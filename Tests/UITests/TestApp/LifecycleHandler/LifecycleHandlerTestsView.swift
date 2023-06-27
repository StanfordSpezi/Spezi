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
    typealias LifecycleHandlerComponent = LifecycleHandlerTestComponent<TestAppStandard>
    
    
    @EnvironmentObject var testAppComponent: LifecycleHandlerComponent
    
    
    var body: some View {
        VStack {
            Text("WillFinishLaunchingWithOptions: \(testAppComponent.willFinishLaunchingWithOptions)")
            Text("SceneWillEnterForeground: \(testAppComponent.sceneWillEnterForeground)")
            Text("SceneDidBecomeActive: \(testAppComponent.sceneDidBecomeActive)")
            Text("SceneWillResignActive: \(testAppComponent.sceneWillResignActive)")
            Text("SceneDidEnterBackground: \(testAppComponent.sceneDidEnterBackground)")
            Text("ApplicationWillTerminate: \(testAppComponent.applicationWillTerminate)")
        }
    }
}
