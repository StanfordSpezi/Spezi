//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


public struct Credentials: Equatable, Identifiable {
    public var username: String
    public var password: String
    
    
    public var id: String {
        username
    }
    
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
