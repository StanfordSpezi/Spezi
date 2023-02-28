//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions


final class OnboardingTests: TestAppUITests {
    func testOnboardingConsent() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["OnboardingTests"].tap()
        app.collectionViews.buttons["Consent View"].tap()
        
        XCTAssert(app.staticTexts["Consent"].exists)
        XCTAssert(app.staticTexts["Version 1.0"].exists)
        XCTAssert(app.staticTexts["This is a markdown example"].exists)
        
        XCTAssertFalse(app.staticTexts["Leland Stanford"].exists)
        XCTAssertFalse(app.staticTexts["X"].exists)
        
        hitConsentButton(app)
        
        #if targetEnvironment(simulator) && (arch(i386) || arch(x86_64))
            throw XCTSkip("PKCanvas view-related tests are currently skipped on Intel-based iOS simulators due to a metal bug on the simulator.")
        #endif
        
        try app.textFields["Enter your first name ..."].enter(value: "Leland")
        try app.textFields["Enter your surname ..."].enter(value: "Stanford")
        
        hitConsentButton(app)
        
        app.staticTexts["Leland Stanford"].swipeRight()
        app.buttons["Undo"].tap()
        
        hitConsentButton(app)
        
        app.staticTexts["X"].swipeRight()
        
        hitConsentButton(app)
        
        XCTAssert(app.staticTexts["Welcome"].exists)
        XCTAssert(app.staticTexts["CardinalKit UI Tests"].exists)
    }
    
    private func hitConsentButton(_ app: XCUIApplication) {
        if app.staticTexts["This is a markdown example"].isHittable {
            app.staticTexts["This is a markdown example"].swipeUp()
        } else {
            print("Can not scroll down.")
        }
        app.buttons["I Consent"].tap()
    }
    
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
        
        XCTAssert(app.staticTexts["Consent"].exists)
        XCTAssert(app.staticTexts["Version 1.0"].exists)
    }
}
