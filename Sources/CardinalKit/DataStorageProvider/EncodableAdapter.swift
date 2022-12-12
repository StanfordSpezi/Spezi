//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public protocol EncodableAdapter<InputType, ID>: Actor {
    /// <#Description#>
    associatedtype InputType: Sendable, Identifiable where InputType.ID: Sendable
    /// <#Description#>
    associatedtype ID: Sendable, Hashable
    
    
    /// <#Description#>
    /// - Parameter element: <#element description#>
    /// - Returns: <#description#>
    func transform(element: InputType) async -> any Encodable & Sendable
    
    /// <#Description#>
    /// - Parameter id: <#id description#>
    /// - Returns: <#description#>
    func transform(id: InputType.ID) async -> ID
}
