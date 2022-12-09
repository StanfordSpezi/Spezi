//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


public struct Localization: Codable {
    public struct Field: Codable {
        public let title: String
        public let placeholder: String
    }
    
    
    public static let `default` = Localization(
        login: Login.default
    )
    
    
    public let login: Login
    
    
    init(
        login: Login = Localization.default.login
    ) {
        self.login = login
    }
}
