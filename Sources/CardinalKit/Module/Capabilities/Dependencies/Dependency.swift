//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public protocol Dependency {
    /// A ``Dependency/ComponentStandard`` defines what ``Standard`` the dependency should support.
    associatedtype ComponentStandard: Standard
    
    
    /// <#Description#>
    /// - Parameter dependencyManager: <#dependencyManager description#>
    func visit(dependencyManager: DependencyManager)
}
