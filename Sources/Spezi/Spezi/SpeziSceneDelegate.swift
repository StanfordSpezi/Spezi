//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


#if os(iOS) || os(visionOS) || os(tvOS)
class SpeziSceneDelegate: NSObject, UISceneDelegate {
    @available(*, deprecated, message: "Propagate deprecation warning.")
    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let delegate = SpeziAppDelegate.appDelegate else {
            return
        }
        delegate.sceneWillEnterForeground(scene)
    }
    
    @available(*, deprecated, message: "Propagate deprecation warning.")
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let delegate = SpeziAppDelegate.appDelegate else {
            return
        }
        delegate.sceneDidBecomeActive(scene)
    }
    
    @available(*, deprecated, message: "Propagate deprecation warning.")
    func sceneWillResignActive(_ scene: UIScene) {
        guard let delegate = SpeziAppDelegate.appDelegate else {
            return
        }
        delegate.sceneWillResignActive(scene)
    }
    
    @available(*, deprecated, message: "Propagate deprecation warning.")
    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let delegate = SpeziAppDelegate.appDelegate else {
            return
        }
        delegate.sceneDidEnterBackground(scene)
    }
}
#endif
