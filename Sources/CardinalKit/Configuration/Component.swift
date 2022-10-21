//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

/// A ``Component`` defines
public protocol Component: _AnyComponent {
    /// A ``Component/ComponentStandard`` defines what ``Standard`` the component supports.
    associatedtype ComponentStandard: Standard
    
    /// The ``Component/configure(cardinalKit:)`` method is called on the initialization of the CardinalKit instance to perform a lightweight configuration of the component.
    ///
    /// If a ``Component`` needs to store a reference to the ``CardinalKit`` instance, it should keep a **weak** reference to the ``CardinalKit`` instance.
    /// It is advised that longer setup tasks are done in an asynchronous task and started during the call of the configure method.
    /// - Parameter cardinalKit: The ``CardinalKit`` instance used in the instance of a CardinalKit project.
    func configure(cardinalKit: CardinalKit<ComponentStandard>)
}


extension Component {
    // A documentation for this methodd exists in the `_AnyComponent` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func configureAny(cardinalKit: Any) {
        guard let typedCardinalKit = cardinalKit as? CardinalKit<ComponentStandard> else {
            return
        }
        
        self.configure(cardinalKit: typedCardinalKit)
    }
}


extension Component where Self: StorageKey {
    typealias Value = Self
    
    
    // A documentation for this methodd exists in the `Component` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func configure(cardinalKit: CardinalKit<ComponentStandard>) {
        cardinalKit.storage.set(Self.self, to: self as? Self.Value)
    }
}
