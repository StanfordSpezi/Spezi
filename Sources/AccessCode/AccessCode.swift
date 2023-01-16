//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


public final class AccessCode<ComponentStandard: Standard>: Component, ObservableObjectProvider {
    private let accessCodeService: AccessCodeService
    
    
    public var observableObjects: [any ObservableObject] {
        [
            accessCodeService
        ]
    }
    
    
    public init(_ accessCodeConfiguration: AccessCodeConfiguration = .codeIfUnprotected()) {
        self.accessCodeService = AccessCodeService()
    }
}
