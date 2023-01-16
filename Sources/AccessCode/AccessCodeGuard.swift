//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// <#Description#>
public struct AccessCodeGuard<GuardedView: View>: View {
    private let guardedView: GuardedView
    @EnvironmentObject private var accessCodeService: AccessCodeService
    
    
    public var body: some View {
        guardedView
    }
    
    
    /// <#Description#>
    /// - Parameter guarded: <#guarded description#>
    public init(@ViewBuilder guarded guardedView: () -> GuardedView) {
        self.guardedView = guardedView()
    }
}


struct AccessCodeGuard_Previews: PreviewProvider {
    static var previews: some View {
        AccessCodeGuard {
            Text("Guarded View")
        }
    }
}
