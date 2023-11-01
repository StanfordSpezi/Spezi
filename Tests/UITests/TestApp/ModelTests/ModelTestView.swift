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


class MyModel2TestCase: TestAppTestCase {
    let model: MyModel2
    let flag: Bool


    init(model: MyModel2, flag: Bool) {
        self.model = model
        self.flag = flag
    }


    func runTests() async throws {
        try XCTAssertEqual(model.message, "Hello World")
        try XCTAssert(flag)
    }
}

struct ModelTestView: View {
    @Environment(MyModel2.self)
    var model
    @Environment(\.customKey)
    var flag

    var body: some View {
        TestAppView(testCase: MyModel2TestCase(model: model, flag: flag))
    }
}
