//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
@_exported import ModelsR4


actor FHIR: Standard {
    typealias BaseType = Resource
    
    
    var resources: [String: ResourceProxy] = [:]
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataSourceElement<BaseType>>) {
        _Concurrency.Task {
            for try await dateSourceElement in asyncSequence {
                switch dateSourceElement {
                case let .addition(resource):
                    guard let id = resource.id?.value?.string else {
                        return
                    }
                    resources[id] = ResourceProxy(with: resource)
                case let .removal(resourceId):
                    guard let id = resourceId?.value?.string else {
                        return
                    }
                    resources[id] = nil
                }
            }
        }
    }
}
