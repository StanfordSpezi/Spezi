//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``DataStorageProvider``  determines a ``Component`` used to process data from a ``Standard``.
/// A ``Standard`` instance can use the ``Standard/DataStorageProviders`` property wrapper to access all related ``DataStorageProvider``s.
///
/// The following example uses an ``EncodableAdapter`` and ``IdentityEncodableAdapter`` to transform elements to an `Encodable` representation:
/// ```
/// private actor DataStorageExample<ComponentStandard: Standard>: DataStorageProvider {
///      typealias Adapter = any EncodableAdapter<ComponentStandard.BaseType, String>
///
///
///      let adapter: Adapter
///
///
///      init(adapter: Adapter) {
///          self.adapter = adapter
///      }
///
///      init() {
///          self.adapter = IdentityEncodableAdapter()
///      }
///
///
///      func process(_ element: DataChange<ComponentStandard.BaseType>) async throws {
///          switch element {
///          case let .addition(element):
///              async let transformedElement = adapter.transform(element: element)
///              let data = try await JSONEncoder().encode(transformedElement)
///              // E.g., Handle the data upload here ...
///          case let .removal(id):
///              async let stringId = transform(id, using: adapter)
///              // E.g., Send out a delete network request here ...
///          }
///      }
///
///
///      private func transform(
///          _ id: ComponentStandard.BaseType.ID,
///          using adapter: some EncodableAdapter<ComponentStandard.BaseType, String>
///      ) async -> String {
///          await adapter.transform(id: id)
///      }
/// }
public protocol DataStorageProvider<ComponentStandard>: Actor, Component {
    /// The ``DataStorageProvider/process(_:)`` function is called for every element should be handled by the ``DataStorageProvider``
    /// - Parameter element: The ``DataChange`` defines if the element should be added or deleted.
    func process(_ element: DataChange<ComponentStandard.BaseType>) async throws
}
