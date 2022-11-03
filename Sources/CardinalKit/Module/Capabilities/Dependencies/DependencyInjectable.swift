//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

protocol DependencyInjectable<DependencyInjectableStandard>: AnyObject {
    associatedtype DependencyInjectableStandard: Standard
    
    
    func gatherDependency(dependencyManager: DependencyManager<DependencyInjectableStandard>)
    func inject(dependencyManager: DependencyManager<DependencyInjectableStandard>)
}
