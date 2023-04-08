//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Foundation


/// <#Description#>
public actor TestAppStandard: Standard, ObservableObjectProvider, ObservableObject {
    public typealias BaseType = TestAppStandardBaseType
    public typealias RemovalContext = TestAppStandardRemovalContext
    
    
    /// <#Description#>
    public struct TestAppStandardBaseType: Identifiable, Sendable {
        /// <#Description#>
        public var id: String
        /// <#Description#>
        public var content: Int
        /// <#Description#>
        public var collectionPath: String
        
        
        /// <#Description#>
        public var removalContext: TestAppStandardRemovalContext {
            TestAppStandardRemovalContext(id: id, collectionPath: collectionPath)
        }
        
        
        /// <#Description#>
        /// - Parameters:
        ///   - id: <#id description#>
        ///   - content: <#content description#>
        ///   - collectionPath: <#collectionPath description#>
        public init(id: String, content: Int = 42, collectionPath: String = "TestAppStandardDataChange") {
            self.collectionPath = collectionPath
            self.id = id
            self.content = content
        }
    }
    
    /// <#Description#>
    public struct TestAppStandardRemovalContext: Identifiable, Sendable {
        /// <#Description#>
        public var id: TestAppStandardBaseType.ID
        /// <#Description#>
        public var collectionPath: String
        
        
        /// <#Description#>
        /// - Parameters:
        ///   - id: <#id description#>
        ///   - collectionPath: <#collectionPath description#>
        public init(id: TestAppStandardBaseType.ID, collectionPath: String = "TestAppStandardDataChange") {
            self.collectionPath = collectionPath
            self.id = id
        }
    }
    
    
    /// <#Description#>
    public private(set) var dataChanges: [DataChange<BaseType, RemovalContext>] = [] {
        willSet {
            Task { @MainActor in
                self.objectWillChange.send()
            }
        }
    }
    
    
    public init() {}
    
    
    /// <#Description#>
    /// - Parameter asyncSequence: <#asyncSequence description#>
    public func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>) {
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
                fatalError(
                    """
                    Unexpected error in \(error).
                    Do not use `fatalError` in production code. We only use this to validate the tests.
                    """
                )
            }
        }
    }
}
