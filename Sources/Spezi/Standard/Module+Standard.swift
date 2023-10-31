//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

extension Module {
    func inject(standard: any Standard) {
        for standardPropertyWrapper in retrieveProperties(ofType: AnyStandardPropertyWrapper.self) {
            standardPropertyWrapper.inject(standard: standard)
        }
    }
}


extension Module {
    /// Defines access to the shared ``Standard`` actor.
    ///
    /// A ``Module`` can define the injection of a ``Standard`` using the @``Module/StandardActor`` property wrapper:
    /// ```swift
    /// class ExampleModule: Module {
    ///     @StandardActor var standard: ExampleStandard
    /// }
    /// ```
    ///
    /// You can access the wrapped value of the ``Standard`` after the ``Module`` is configured using ``Module/configure()-5pa83``,
    /// e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp`` function.
    public typealias StandardActor = _StandardPropertyWrapper
}
