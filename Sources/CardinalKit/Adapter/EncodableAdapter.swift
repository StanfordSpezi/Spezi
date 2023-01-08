//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// An ``EncodableAdapter`` is an ``Adapter`` to transform a type to an `Encodable` instance. It is typically used in instantiations of a ``DataStorageProvider``.
///
/// You can refer to the ``IdentityEncodableAdapter`` if you require a default adapter for a type that already conforms to all required protocols.
public protocol EncodableAdapter<InputElement>: SingleValueAdapter where OutputElement: Encodable {}
