//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Standard {
    nonisolated func inject(dataStorageProviders: [any DataStorageProvider<Self>]) {
        for provider in retrieveProperties(ofType: DataStorageProviders.self) {
            provider.inject(dataStorageProviders: dataStorageProviders)
        }
    }
}


extension Standard {
    /// Defines access to the data storage providers in the ``Standard`` actor.
    ///
    /// A ``Standard`` can gain access to all data storage providers using the @``Standard/DataStorageProviders`` property wrapper:
    /// ```swift
    /// actor ExampleStandard: Standard {
    ///     @DataStorageProviders
    ///     var dataSources: [any DataStorageProvider<ExampleStandard>]
    ///
    ///     // ...
    /// }
    /// ```
    /// 
    /// You can access the wrapped value of the `@` ``Standard/DataStorageProviders`` after the ``Standard`` is configured using ``Component/configure()-27tt1``,
    /// e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp`` function.
    public typealias DataStorageProviders = _DataStorageProvidersPropertyWrapper<Self>
}
