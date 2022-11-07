//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public protocol DependencyDescriptor<PropertyStandard> {
    associatedtype PropertyStandard: Standard
    
    
    func gatherDependency(dependencyManager: DependencyManager<PropertyStandard>)
    func inject(dependencyManager: DependencyManager<PropertyStandard>)
}


extension Component {
    var dependencyDescriptors: [any DependencyDescriptor<ComponentStandard>] {
        let mirror = Mirror(reflecting: self)
        var dependencies: [any DependencyDescriptor<ComponentStandard>] = []
        
        for child in mirror.children {
            guard let dependencyPropertyWrapper = child.value as? any DependencyDescriptor<ComponentStandard> else {
                continue
            }
            dependencies.append(dependencyPropertyWrapper)
        }
        
        return dependencies
    }
}
