//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


public protocol AccountService: Identifiable {
    var loginButton: AnyView { get }
    var registerButton: AnyView { get }
    
    
    init(account: Account)
}


extension AccountService {
    public var registerButton: AnyView {
        loginButton
    }
    
    public var id: String {
        String(describing: type(of: self))
    }
}
