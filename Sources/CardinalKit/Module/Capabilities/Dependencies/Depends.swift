//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public struct Depends<T: Component>: Dependency {
    public typealias ComponentStandard = T.ComponentStandard
    
    
    let defaultValue: () -> (T)
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - dependencyType: <#dependencyType description#>
    ///   - defaultValue: <#defaultValue description#>
    public init(on dependencyType: T.Type = T.self, defaultValue: @autoclosure @escaping () -> T) {
        self.defaultValue = defaultValue
    }
    
    
    public func visit(dependencyManager: DependencyManager) {
        dependencyManager.require(T.self, defaultValue: defaultValue())
    }
}
