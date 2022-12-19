//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


actor Lock {
    var lock = false
    
    
    func enter(_ closure: () -> Void) {
        precondition(lock == false)
        lock = true
        closure()
        lock = false
    }
}
