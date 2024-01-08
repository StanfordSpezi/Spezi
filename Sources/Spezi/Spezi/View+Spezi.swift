//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI
import XCTRuntimeAssertions


struct SpeziViewModifier: ViewModifier {
    let speziViewModifiers: [any ViewModifier]
    
    
    init(_ anySpezi: AnySpezi) {
        self.speziViewModifiers = anySpezi.viewModifiers
    }
    
    
    func body(content: Content) -> some View {
        speziViewModifiers.modify(content)
    }
}


/// Options to simulate behavior for a ``LifecycleHandler`` in cases where there is no app delegate like in Preview setups.
public enum LifecycleSimulationOptions {
    /// Simulation is disabled.
    case disabled
    /// The ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp`` method will be called for all
    /// configured ``Module``s that conform to ``LifecycleHandler``.
    case launchWithOptions(_ launchOptions: [UIApplication.LaunchOptionsKey: Any])
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
    ///   - standard: The global  ``Standard`` used throughout the app to manage global data flow.
    ///   - simulateLifecycle: Options to simulate behavior for ``LifecycleHandler``s.
    ///   - modules: The ``Module``s used in the Spezi project.
    /// - Returns: The configured view using the Spezi framework.
    public func previewWith<S: Standard>(
        standard: S,
        simulateLifecycle: LifecycleSimulationOptions = .disabled,
        @ModuleBuilder _ modules: () -> ModuleCollection
    ) -> some View {
        let _ = precondition(
            ProcessInfo.processInfo.isPreviewSimulator,
            "The Spezi previewWith(standard:_:) modifier can only used within Xcode preview processes."
        )

        let spezi = Spezi(standard: standard, modules: modules().elements)
        let lifecycleHandlers = spezi.lifecycleHandler

        return modifier(SpeziViewModifier(spezi))
            .task {
                if case let .launchWithOptions(options) = simulateLifecycle {
                    await lifecycleHandlers.willFinishLaunchingWithOptions(UIApplication.shared, launchOptions: options)
                }
            }
    }

    /// Configure Spezi for your previews using a collection of Modules.
    ///
    /// This modifier can be used to configure Spezi with a collection of Modules without declaring a ``SpeziAppDelegate``.
    ///
    /// - Important: This modifier is only recommended for Previews. As it doesn't configure a ``SpeziAppDelegate`` lifecycle handling
    ///     functionality, using ``LifecycleHandler``,  of modules won't work.
    ///
    /// - Parameters:
    ///   - simulateLifecycle: Options to simulate behavior for ``LifecycleHandler``s.
    ///   - modules: The ``Module``s used in the Spezi project.
    /// - Returns: The configured view using the Spezi framework.
    public func previewWith(
        simulateLifecycle: LifecycleSimulationOptions = .disabled,
        @ModuleBuilder _ modules: () -> ModuleCollection
    ) -> some View {
        previewWith(standard: DefaultStandard(), simulateLifecycle: simulateLifecycle, modules)
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
