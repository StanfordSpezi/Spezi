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
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Canvas"].tap()
    }
    
    func testNameFields() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Name Fields"].tap()
    }
    
    func testUserProfile() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["User Profile"].tap()
    }
    
    func testGeometryReader() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Geometry Reader"].tap()
    }
    
    func testLabel() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Label"].tap()
    }
    
    func testMardownView() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["Markdown View"].tap()
    }
    
    func testViewState() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["Views"].tap()
        app.collectionViews.buttons["View State"].tap()
    }
}
