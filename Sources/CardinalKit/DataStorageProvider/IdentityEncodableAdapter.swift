//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public actor IdentityEncodableAdapter<InputType>: EncodableAdapter
    where InputType: Encodable & Sendable & Identifiable, InputType.ID: LosslessStringConvertible {
    /// <#Description#>
    public init() {}
    
    
    public func transform(element: InputType) async -> Encodable  & Sendable {
        element
    }
    
    public func transform(id: InputType.ID) async -> String {
        id.description
    }
}
