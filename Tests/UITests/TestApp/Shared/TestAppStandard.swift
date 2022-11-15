//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Foundation


actor TestAppStandard: Standard, ObservableObjectComponent, ObservableObject {
    typealias BaseType = TestAppStandardDataSourceElement
    
    
    struct TestAppStandardDataSourceElement: Identifiable {
        let id: String
    }
    
    
    var dataSourceElements: [DataSourceElement<BaseType>] = [] {
        willSet {
            Task { @MainActor in
                self.objectWillChange.send()
            }
        }
    }
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataSourceElement<BaseType>>) {
        Task {
            do {
                for try await element in asyncSequence {
                    switch element {
                    case let .addition(newElement):
                        print("Added \(newElement)")
                    case let .removal(deletedElementId):
                        print("Removed element with \(deletedElementId)")
                    }
                    dataSourceElements.append(element)
                }
            } catch {
                dataSourceElements = [.removal(error.localizedDescription)]
            }
        }
    }
}
