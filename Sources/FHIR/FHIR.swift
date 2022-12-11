//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_exported import ModelsR4
import CardinalKit


actor FHIR: Standard {
    typealias BaseType = ResourceProxy
    
    
    var resources: [FHIRString: ResourceProxy] = [:]
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataSourceElement<BaseType>>) {
        _Concurrency.Task {
            for try await dateSourceElement in asyncSequence {
                switch dateSourceElement {
                case let .addition(resource):
                    guard let id = resource.id else {
                        return
                    }
                    resources[id] = resource
                case let .removal(resourceId):
                    guard let id = resourceId else {
                        return
                    }
                    resources[id] = nil
                }
            }
        }
    }
}
