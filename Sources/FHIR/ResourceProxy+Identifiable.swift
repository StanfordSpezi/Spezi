//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4


extension ResourceProxy: Identifiable {
    public var id: FHIRString? {
        self.get().id?.value
    }
}
