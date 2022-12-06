//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class AccountTests: TestAppUITests {
    func testAccountComponents() throws { // swiftlint:disable:this function_body_length
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Account"].tap()
    }
}
