//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// A ``Component`` can conform to ``ObservableObjectProvider`` to inject `ObservableObject`s in the SwiftUI view hierarchy using ``ObservableObjectProvider/observableObjects-6w1nz``
///
///
/// Reference types conforming to `ObservableObject` can be used in SwiftUI views to inform a view about changes in the object.
/// You can create and use them in a view using `@ObservedObject` or get it from the SwiftUI environment using `@EnvironmentObject`.
///
/// A Component can conform to `ObservableObjectProvider` to inject `ObservableObject`s in the SwiftUI view hierarchy.
/// You define all `ObservableObject`s that should be injected using the ``ObservableObjectProvider/observableObjects-5nl18`` property.
/// ```swift
/// class MyComponent<ComponentStandard: Standard>: ObservableObjectProvider {
///     public var observableObjects: [any ObservableObject] {
///         [/* ... */]
///     }
/// }
/// ```
///
/// `ObservableObjectProvider` provides a default implementation of the ``ObservableObjectProvider/observableObjects-5nl18`` If your type conforms to `ObservableObject`
/// that just injects itself into the SwiftUI view hierarchy:
/// ```swift
/// class MyComponent<ComponentStandard: Standard>: ObservableObject, ObservableObjectProvider {
///     @Published
///     var test: String
///
///     // ...
/// }
/// ```
public protocol ObservableObjectProvider {
    /// The `ObservableObject` instances that should be injected in the SwiftUI environment.
    ///
    /// You define all `ObservableObject`s that should be injected using the ``ObservableObjectProvider/observableObjects-5nl18`` property.
    /// ```swift
    /// class MyComponent<ComponentStandard: Standard>: ObservableObjectProvider {
    ///     public var observableObjects: [any ObservableObject] {
    ///         [/* ... */]
    ///     }
    /// }
    /// ```
    ///
    /// `ObservableObjectProvider` provides a default implementation of the ``ObservableObjectProvider/observableObjects-5nl18`` If your type conforms to `ObservableObject`
    /// that just injects itself into the SwiftUI view hierarchy.
    var observableObjects: [any ObservableObject] { get }
}


private struct ObservableObjectInjectionViewModifier: ViewModifier {
    let apply: (AnyView) -> AnyView
    
    
    init<O: ObservableObject>(observableObject: O) {
        apply = { view in
            AnyView(view.environmentObject(observableObject))
        }
    }
    
    
    func body(content: Content) -> some View {
        apply(AnyView(content))
    }
}


extension ObservableObjectProvider {
    // A documentation for this methodd exists in the `ObservableObjectProvider` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public var observableObjects: [any ObservableObject] {
        []
    }
    
    
    func inject(in view: AnyView) -> AnyView {
        var view = view
        for observableObject in observableObjects {
            let modifier = ObservableObjectInjectionViewModifier(observableObject: observableObject)
            view = AnyView(view.modifier(modifier))
        }
        return view
    }
}

extension ObservableObjectProvider where Self: ObservableObject {
    // A documentation for this methodd exists in the `ObservableObjectProvider` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public var observableObjects: [any ObservableObject] {
        [self]
    }
}
