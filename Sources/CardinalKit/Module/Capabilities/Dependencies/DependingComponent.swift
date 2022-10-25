//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// <#Description#>
public protocol DependingComponent: AnyObject {
    /// <#Description#>
    /// - Parameter dependencyManager: <#dependencyManager description#>
    func dependencyResolution(_ dependencyManager: DependencyManager)
}


extension DependingComponent {
    // A documentation for this methodd exists in the `DependingComponent` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public func dependencyResolution(_ dependencyManager: DependencyManager) {
        dependencyManager.passedAllRequirements(self)
    }
}
