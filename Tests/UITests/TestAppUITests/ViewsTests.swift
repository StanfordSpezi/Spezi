//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class ViewsTests: TestAppUITests {
    func testCanvas() throws {
        #if targetEnvironment(simulator) && (arch(i386) || arch(x86_64))
            throw XCTSkip("PKCanvas view-related tests are currently skipped on Intel-based iOS simulators due to a metal bug on the simulator.")
        #endif
        
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Canvas"].tap()
        
        XCTAssert(app.staticTexts["Did Draw Anything: false"].waitForExistence(timeout: 1))
        XCTAssertFalse(app.scrollViews.otherElements.images["palette_tool_pencil_base"].waitForExistence(timeout: 1))
        
        let canvasView = app.scrollViews.firstMatch
        canvasView.swipeRight()
        canvasView.swipeDown()
        
        XCTAssert(app.staticTexts["Did Draw Anything: true"].exists)
        
        app.buttons["Show Tool Picker"].tap()
        
        XCTAssert(app.scrollViews.otherElements.images["palette_tool_pencil_base"].waitForExistence(timeout: 1))
        canvasView.swipeLeft()
        
        app.buttons["Show Tool Picker"].tap()
        
        XCTAssertFalse(app.scrollViews.otherElements.images["palette_tool_pencil_base"].waitForExistence(timeout: 1))
        canvasView.swipeUp()
    }
    
    func testNameFields() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Name Fields"].tap()
        
        XCTAssert(app.staticTexts["First Title"].exists)
        XCTAssert(app.staticTexts["Second Title"].exists)
        XCTAssert(app.staticTexts["Given Name"].exists)
        XCTAssert(app.staticTexts["Family Name"].exists)
        
        app.textFields["First Placeholder"].enter(value: "Le")
        app.textFields["Second Placeholder"].enter(value: "Stan")
        
        app.textFields["Enter your given name ..."].enter(value: "land")
        app.textFields["Enter your family name ..."].enter(value: "ford")
        
        XCTAssert(app.textFields["Leland"].exists)
        XCTAssert(app.textFields["Stanford"].exists)
    }
    
    func testUserProfile() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["User Profile"].tap()
        
        XCTAssertTrue(app.staticTexts["PS"].exists)
        XCTAssertTrue(app.staticTexts["LS"].exists)
        
        XCTAssertTrue(app.images["person.crop.artframe"].waitForExistence(timeout: 1.0))
    }
    
    func testGeometryReader() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Geometry Reader"].tap()
        
        XCTAssert(app.staticTexts["300.000000"].exists)
        XCTAssert(app.staticTexts["200.000000"].exists)
    }
    
    func testLabel() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Label"].tap()
        
        // The string value needs to be searched for in the UI.
        // swiftlint:disable:next line_length
        let text = "This is a label ... An other text. This is longer and we can check if the justified text works as epxected. This is a very long text."
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label.contains(text) }.count, 2)
    }
    
    func testLazyText() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Lazy Text"].tap()
        
        XCTAssert(app.staticTexts["This is a long text ..."].exists)
        XCTAssert(app.staticTexts["And some more lines ..."].exists)
        XCTAssert(app.staticTexts["And a third line ..."].exists)
    }
    
    func testMardownView() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Markdown View"].tap()
        
        XCTAssert(app.staticTexts["This is a markdown example."].exists)
        XCTAssert(app.staticTexts["idle"].exists)
        XCTAssert(app.staticTexts["Header"].exists)
        
        sleep(6)
        
        XCTAssert(app.staticTexts["This is a markdown example taking 5 seconds to load."].exists)
    }
    
    func testViewState() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["View State"].tap()
        
        XCTAssert(app.staticTexts["View State: processing"].exists)
        
        sleep(6)
        
        let alert = app.alerts.firstMatch.scrollViews.otherElements
        XCTAssert(alert.staticTexts["Error Description"].exists)
        XCTAssert(alert.staticTexts["Failure Reason\n\nHelp Anchor\n\nRecovery Suggestion"].exists)
        alert.buttons["OK"].tap()
        
        app.staticTexts["View State: idle"].tap()
    }
}
