//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

extension Component {
    func inject(standard: ComponentStandard) {
        for standardPropertyWrapper in retrieveProperties(ofType: _StandardPropertyWrapper<ComponentStandard>.self) {
            standardPropertyWrapper.inject(standard: standard)
        }
    }
}


extension Component {
    /// Defines access to the shared ``Standard`` actor.
    ///
    /// A ``Component`` can define the injection of a ``Standard`` using the @``Component/StandardActor`` property wrapper:
    /// ```swift
    /// class ExampleComponent: Component {
    ///     typealias ComponentStandard = ExampleStandard
    ///
    ///     @StandardActor var standard: ExampleStandard
    /// }
    /// ```
    ///
    /// You can access the wrapped value of the ``Standard`` after the ``Component`` is configured using ``Component/configure()-27tt1``,
    /// e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp`` function.
    public typealias StandardActor = _StandardPropertyWrapper<ComponentStandard>
}
