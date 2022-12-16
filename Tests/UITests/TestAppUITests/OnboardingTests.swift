//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class OnboardingTests: TestAppUITests {
    func testOnboardingView() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["OnboardingTests"].tap()
        app.collectionViews.buttons["Onboarding View"].tap()
        
        XCTAssert(app.staticTexts["Welcome"].exists)
        XCTAssert(app.staticTexts["CardinalKit UI Tests"].exists)
        
        XCTAssert(app.images["Decrease Speed"].exists)
        XCTAssert(app.staticTexts["Tortoise"].exists)
        XCTAssert(app.staticTexts["A Tortoise!"].exists)
        
        XCTAssert(app.images["lizard.fill"].exists)
        XCTAssert(app.staticTexts["Lizard"].exists)
        XCTAssert(app.staticTexts["A Lizard!"].exists)
        
        XCTAssert(app.images["tree.fill"].exists)
        XCTAssert(app.staticTexts["Tree"].exists)
        XCTAssert(app.staticTexts["A Tree!"].exists)
        
        app.buttons["Learn More"].tap()
        
        XCTAssert(app.staticTexts["Things to know"].exists)
        XCTAssert(app.staticTexts["And you should pay close attention ..."].exists)
    }
    
    func testSequencialOnboarding() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["OnboardingTests"].tap()
        app.collectionViews.buttons["Sequential Onboarding"].tap()
        
        XCTAssert(app.staticTexts["Things to know"].exists)
        XCTAssert(app.staticTexts["And you should pay close attention ..."].exists)
        
        XCTAssert(app.staticTexts["1"].exists)
        XCTAssert(app.staticTexts["A thing to know"].exists)
        XCTAssertFalse(app.staticTexts["2"].exists)
        XCTAssertFalse(app.staticTexts["A second thing to know"].exists)
        XCTAssertFalse(app.staticTexts["3"].exists)
        XCTAssertFalse(app.staticTexts["Third thing to know"].exists)
        
        app.buttons["Next"].tap()
        XCTAssert(app.staticTexts["2"].exists)
        XCTAssert(app.staticTexts["Second thing to know"].exists)
        
        app.buttons["Next"].tap()
        XCTAssert(app.staticTexts["3"].exists)
        XCTAssert(app.staticTexts["Third thing to know"].exists)
        
        XCTAssert(app.staticTexts["1"].exists)
        XCTAssert(app.staticTexts["A thing to know"].exists)
        XCTAssert(app.staticTexts["2"].exists)
        XCTAssert(app.staticTexts["Second thing to know"].exists)
        XCTAssert(app.staticTexts["3"].exists)
        XCTAssert(app.staticTexts["Third thing to know"].exists)
        app.buttons["Continue"].tap()
        
        XCTAssert(app.staticTexts["Welcome"].exists)
        XCTAssert(app.staticTexts["CardinalKit UI Tests"].exists)
    }
}
