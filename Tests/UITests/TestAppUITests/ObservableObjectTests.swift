//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class ObservableObjectTests: XCTestCase {
    func testObservableObject() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["ObservableObject"].tap()
        
        XCTAssert(app.staticTexts["Passed"].waitForExistence(timeout: 1))
    }
}
