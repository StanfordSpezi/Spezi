//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Foundation
@_exported import ModelsR4
import XCTRuntimeAssertions


actor FHIR: Standard {
    typealias BaseType = Resource
    
    
    var resources: [String: ResourceProxy] = [:]
    
    @DataStorageProviders
    var dataSources: [any DataStorageProvider<FHIR>]
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType>>) {
        _Concurrency.Task {
            for try await dateSourceElement in asyncSequence {
                switch dateSourceElement {
                case let .addition(resource):
                    guard let id = resource.id?.value?.string else {
                        return
                    }
                    resources[id] = ResourceProxy(with: resource)
                    for dataSource in dataSources {
                        try await dataSource.process(.addition(resource))
                    }
                case let .removal(resourceId):
                    guard let id = resourceId?.value?.string else {
                        return
                    }
                    resources[id] = nil
                    for dataSource in dataSources {
                        try await dataSource.process(.removal(resourceId))
                    }
                }
            }
        }
    }
}
