//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Dispatch
import Foundation
import SwiftUI


struct CardinalKitViewModifier: ViewModifier {
    private static var observableObjectProviders: [ObservableObjectProvider]? // swiftlint:disable:this discouraged_optional_collection
    
    
    fileprivate init(_ anyCardinalKit: AnyCardinalKit) {
        guard CardinalKitViewModifier.observableObjectProviders == nil else {
            assertionFailure(
                """
                The `cardinalKit(_:CardinalKitAppDelegate)` modifier is used multiple times.
                The modifier should only be used once in your application.
                """
            )
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            CardinalKitViewModifier.observableObjectProviders = await anyCardinalKit.observableObjectProviders
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    
    func body(content: Content) -> some View {
        guard let observableObjectProviders = CardinalKitViewModifier.observableObjectProviders else {
            return AnyView(content)
        }
        
        return AnyView(content.inject(observableObjectProviders: observableObjectProviders))
    }
}


extension View {
    /// Use the `cardinalKit()` `View` modifier to configure CardinalKit for your application.
    /// - Parameter delegate: The `CardinalKitAppDelegate` used in the SwiftUI `App` instance.
    /// - Returns: A SwiftUI view configured using the CardinalKit framework
    public func cardinalKit(_ delegate: CardinalKitAppDelegate) -> some View {
        modifier(CardinalKitViewModifier(delegate.cardinalKit))
    }
}
