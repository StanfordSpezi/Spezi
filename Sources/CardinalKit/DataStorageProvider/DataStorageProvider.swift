//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public protocol DataStorageProvider<ComponentStandard>: Actor, Component {
    /// <#Description#>
    /// - Parameter element: <#element description#>
    func process(_ element: DataSourceElement<ComponentStandard.BaseType>) async throws
}
