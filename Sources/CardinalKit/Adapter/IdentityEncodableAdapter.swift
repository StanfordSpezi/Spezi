//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


///// The ``IdentityEncodableAdapter`` is an instantiation of the ``EncodableAdapter`` protocol that maps an input type conforming
///// to `Encodable & Sendable & Identifiable` and with the `InputType.ID` type conforming to `LosslessStringConvertible`.
// public actor IdentityEncodableAdapter<
//    InputElement: Identifiable & Sendable & Encodable,
//    InputRemovalContext,
//    OutputRemovalContext
// >: EncodableAdapter where InputElement.ID: LosslessStringConvertible & Sendable {
//    public init() {}
//
//
//    public func transform(element: InputElement) -> any Identifiable & Sendable & Encodable {
//        element
//    }
//
//    public func transform(id: InputRemovalContext) -> OutputRemovalContext {
//        id.description
//    }
// }
