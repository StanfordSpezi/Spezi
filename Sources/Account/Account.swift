//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


open class Account: ObservableObject, ObservableObjectComponent, TypedCollectionKey, DefaultInitializable {
    public typealias Value = Account
    
    
    open lazy var accountServices: [any AccountService] = [
        UsernamePasswordAccountService(account: self),
        EmailPasswordLoginService(account: self)
    ]
    open var user: User?
    
    
    public var observableObject: Account {
        self
    }
    
    
    public required init() {}
}
