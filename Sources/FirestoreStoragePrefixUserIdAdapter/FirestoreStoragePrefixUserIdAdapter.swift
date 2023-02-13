//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FirebaseAuth
import FirestoreDataStorage


/// <#Description#>
public actor FirestoreStoragePrefixUserIdAdapter: SingleValueAdapter {
    public typealias InputElement = FirestoreElement
    public typealias InputRemovalContext = FirestoreRemovalContext
    public typealias OutputElement = FirestoreElement
    public typealias OutputRemovalContext = FirestoreRemovalContext
    
    
    public init() {}
    
    
    public func transform(element: FirestoreElement) throws -> FirestoreElement {
        guard let userID = Auth.auth().currentUser?.uid else {
            throw FirestoreStoragePrefixUserIdAdapterError.userNotSignedIn
        }
        
        var modifiedElement = element
        modifiedElement.collectionPath = userID.id + "/" + element.collectionPath
        return modifiedElement
    }
    
    public func transform(removalContext: FirestoreRemovalContext) throws -> FirestoreRemovalContext {
        guard let userID = Auth.auth().currentUser?.uid else {
            throw FirestoreStoragePrefixUserIdAdapterError.userNotSignedIn
        }
        
        var modifiedRemovalContext = removalContext
        modifiedRemovalContext.collectionPath = userID.id + "/" + removalContext.collectionPath
        return modifiedRemovalContext
    }
}
