//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

/// A ``Standard`` defines a common representation of resources used by different `CardinalKit` components.
///
/// A ``Standard`` is a ``DataSourceRegistry`` that needs to define a ``DataSourceRegistry/BaseType`` and a ``DataSourceRegistry/RemovalContext``
/// and a ``DataSourceRegistry/registerDataSource(_:)`` method.
/// Different ``Standard``s can define different ``DataSourceRegistry/BaseType`` and a ``DataSourceRegistry/RemovalContext`` forming a central representation
/// that is shared across ``Component``s.
///
/// The following example demonstrates a minimal ``Standard`` implementation.
/// ```swift
/// actor TestAppStandard: Standard, ObservableObjectProvider, ObservableObject {
///     typealias BaseType = TestAppStandardBaseType
///     typealias RemovalContext = TestAppStandardRemovalContext
///
///
///     struct TestAppStandardBaseType: Identifiable, Sendable {
///         var id: String
///         var content: Int
///
///
///         var removalContext: TestAppStandardRemovalContext {
///             TestAppStandardRemovalContext(id: id)
///         }
///     }
///
///     struct TestAppStandardRemovalContext: Identifiable, Sendable {
///         var id: TestAppStandardBaseType.ID
///     }
///
///
///     func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>) {
///         // ...
///     }
/// }
/// ```
///
/// You can access the current ``Standard`` instance in your ``Component`` or ``Module`` using the @``Component/StandardActor`` property wrapper.
///
/// CardinalKit includes a built-in `FHIR` standard that you can use in your digital health applications.
public protocol Standard<BaseType>: Actor, Component, DataSourceRegistry where ComponentStandard == Self { }
