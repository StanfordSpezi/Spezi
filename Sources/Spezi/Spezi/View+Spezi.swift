//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Dispatch
import Foundation
import SwiftUI


struct SpeziViewModifier: ViewModifier {
    let speziViewModifiers: [any ViewModifier]
    
    
    init(_ anySpezi: AnySpezi) {
        self.speziViewModifiers = anySpezi.viewModifiers
    }
    
    
    func body(content: Content) -> some View {
        speziViewModifiers.modify(content)
    }
}


extension View {
    /// Configure Spezi for your application using a delegate.
    /// - Parameter delegate: The ``SpeziAppDelegate`` used in the SwiftUI App instance.
    /// - Returns: The configured view using the Spezi framework.
    public func spezi(_ delegate: SpeziAppDelegate) -> some View {
        modifier(SpeziViewModifier(delegate.spezi))
    }

    /// Configure Spezi for your previews using a Standard and a collection of Modules.
    ///
    /// This modifier can be used to configure Spezi with a Standard a collection of Modules without declaring a ``SpeziAppDelegate``.
    ///
    /// - Important: This modifier is only recommended for Previews. As it doesn't configure a ``SpeziAppDelegate`` lifecycle handling
    ///     functionality, using ``LifecycleHandler``,  of modules won't work.
    ///
    /// - Parameters:
    ///   - standard: The global ``Standard`` used throughout the app to manage global data flow.
    ///   - modules: The ``Module``s used in the Spezi project.
    /// - Returns: The configured view using the Spezi framework.
    public func spezi<S: Standard>(standard: S, @ModuleBuilder _ modules: () -> ModuleCollection) -> some View {
        modifier(SpeziViewModifier(Spezi(standard: standard, modules: modules().elements)))
    }

    /// Configure Spezi for your previews using a collection of Modules.
    ///
    /// This modifier can be used to configure Spezi with a collection of Modules without declaring a ``SpeziAppDelegate``.
    ///
    /// - Important: This modifier is only recommended for Previews. As it doesn't configure a ``SpeziAppDelegate`` lifecycle handling
    ///     functionality, using ``LifecycleHandler``,  of modules won't work.
    ///
    /// - Parameter modules: The ``Module``s used in the Spezi project.
    /// - Returns: The configured view using the Spezi framework.
    public func spezi(@ModuleBuilder _ modules: () -> ModuleCollection) -> some View {
        spezi(standard: DefaultStandard(), modules)
    }
}


extension Array where Element == any ViewModifier {
    fileprivate func modify<V: View>(_ view: V) -> AnyView {
        var view = AnyView(view)
        for modifier in self {
            view = modifier.modify(view)
        }
        return view
    }
}


extension ViewModifier {
    fileprivate func modify(_ view: AnyView) -> AnyView {
        AnyView(view.modifier(self))
    }
}
