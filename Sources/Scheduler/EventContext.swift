//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


protocol EventContext: AnyObject {
    var id: UUID { get }
    var schedule: Schedule { get }
    var completedEvents: [Date: Event] { get set }
}
