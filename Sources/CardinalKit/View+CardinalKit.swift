//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct CardinalKitViewModifier: ViewModifier {
    @State
    var cardinalKit: CardinalKit
    
    
    fileprivate init(cardinalKit: CardinalKit) {
        self.cardinalKit = cardinalKit
    }
    
    
    func body(content: Content) -> some View {
        content
            .environmentObject(cardinalKit)
    }
}

extension View {
    /// Use the `cardinalKit()` `View` modifier to configure CardinalKit for your application.
    /// - Parameter delegate: The `CardinalKitAppDelegate` used in the SwiftUI `App` instance.
    /// - Returns: A SwiftUI view configured using the CardinalKit framework
    public func cardinalKit(_ delegate: CardinalKitAppDelegate) -> some View {
        modifier(CardinalKitViewModifier(cardinalKit: delegate.cardinalKit))
    }
}
