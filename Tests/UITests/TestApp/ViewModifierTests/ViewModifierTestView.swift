//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI
import XCTestApp
import XCTSpezi


class MyModelTestCase: TestAppTestCase {
    let model: MyModel


    init(model: MyModel) {
        self.model = model
    }


    func runTests() async throws {
        try XCTAssertEqual(model.message, "Hello World")
    }
}


struct ViewModifierTestView: View {
    @Environment(MyModel.self)
    var model


    var body: some View {
        TestAppView(testCase: MyModelTestCase(model: model))
    }
}
