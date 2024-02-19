//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


protocol AnyStandardPropertyWrapper {
    func inject<S: Standard>(standard: S)
}


extension Module {
    func inject(standard: any Standard) {
        for standardPropertyWrapper in retrieveProperties(ofType: AnyStandardPropertyWrapper.self) {
            standardPropertyWrapper.inject(standard: standard)
        }
    }
}
