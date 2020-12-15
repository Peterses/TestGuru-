//
//  UITestRegisterView.swift
//  TestGuru!UITests
//
//  Created by Peterses on 02/12/2020.
//

import XCTest

class UITestRegisterView: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testInValidEmail_missingEmailField() {
        
        
        let app = XCUIApplication()
        app.buttons["Login"].staticTexts["Login"].tap()
        app.buttons["Zaloguj"].staticTexts["Zaloguj"].tap()
        let alertDialog = app.alerts["Error"]
        
        XCTAssertTrue(alertDialog.exists)
        
    }

}
