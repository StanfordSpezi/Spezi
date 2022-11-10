//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


protocol HealthKitComponent: Component, LifecycleHandler {
    func askedForAuthorization()
}


extension HealthKitComponent {
    var askedForAuthorization: Bool {
        @AppStorage("CardinalKit.HealthKit.didAskForAuthorization") var didAskForAuthorization = false
        return didAskForAuthorization
    }
}
