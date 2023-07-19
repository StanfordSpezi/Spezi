//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


// note: detailed documentation is provided as an article extension in the DocC bundle
/// A `Component` defines a software subsystem that can be configured as part of the ``SpeziAppDelegate/configuration``.
public protocol Component<ComponentStandard>: AnyObject, KnowledgeSource<SpeziAnchor> {
    /// A ``Component/ComponentStandard`` defines what ``Standard`` the component supports.
    associatedtype ComponentStandard: Standard
    
    /// The ``Component/configure()-27tt1`` method is called on the initialization of the Spezi instance to perform a lightweight configuration of the component.
    ///
    /// Both ``Component/Dependency`` and ``Component/DynamicDependencies`` are available and configured at this point.
    /// It is advised that longer setup tasks are done in an asynchronous task and started during the call of the configure method.
    func configure()
}


extension Component {
    // A documentation for this method exists in the `Component` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func configure() {}
}
