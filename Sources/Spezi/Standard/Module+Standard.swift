//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Module {
    /// Defines access to the shared `Standard` actor.
    ///
    /// A ``Module`` can define the injection of a ``Standard`` using the @``Module/StandardActor`` property wrapper.
    ///
    /// - Note: You can access `@StandardActor` once your ``Module/configure()-5pa83`` method is called (e.g., it must not be used in the `init`)
    ///     and can continue to access the Standard actor in methods like ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp``.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @StandardActor var standard: ExampleStandard
    ///
    ///     // You can omit the type to get an `any Standard`:
    ///     @StandardActor var standard
    ///
    ///     // You also can specify a protocol to cast the standard to a constraint:
    ///     @StandardActor var standard: any HealthKitConstraint
    ///
    ///     // And you can make the type optional if the app isn't required to conform its standard to the protocol:
    ///     @StandardActor var standard: (any HealthKitConstraint)?
    /// }
    /// ```
    public typealias StandardActor = _StandardPropertyWrapper
}
