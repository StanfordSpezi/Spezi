//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Foundation


actor TestAppStandard: Standard, ObservableObjectProvider, ObservableObject {
    typealias BaseType = TestAppStandardDataChange
    
    
    struct TestAppStandardDataChange: Identifiable {
        let id: String
    }
    
    
    var dataChanges: [DataChange<BaseType>] = [] {
        willSet {
            Task { @MainActor in
                self.objectWillChange.send()
            }
        }
    }
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType>>) {
        Task {
            do {
                for try await element in asyncSequence {
                    switch element {
                    case let .addition(newElement):
                        print("Added \(newElement)")
                    case let .removal(deletedElementId):
                        print("Removed element with \(deletedElementId)")
                    }
                    dataChanges.append(element)
                }
            } catch {
                dataChanges = [.removal(error.localizedDescription)]
            }
        }
    }
}
