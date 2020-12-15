//
//  UITest_LoginView.swift
//  TestGuru!UITests
//
//  Created by Peterses on 02/12/2020.
//

import XCTest

class UITest_LoginView: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testInvalidEmail_emailNilPasswordNotNil() {
        app.launch()
        app.buttons["Login"].tap()
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("12345678")
        
        app.staticTexts["Zaloguj"].tap()
        let alertDialog = app.alerts["Error"]
        let alertLabel = "Email or password are missing."
        
        XCTAssert(app.alerts.element.staticTexts[alertLabel].exists)
        XCTAssertTrue(alertDialog.exists)
    }
    
    func testInvalidEmail_emailNotExistsPasswordNotNil() {
        app.launch()
        app.buttons["Login"].tap()
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("wrongEmail@email.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("12345678")
        app.staticTexts["Zaloguj"].tap()
        let alertDialog = app.alerts["Error"]
        let alertLabel = "User not found."
        
        alertDialog.waitForExistence(timeout: 5)
        
        XCTAssert(app.alerts.element.staticTexts[alertLabel].exists)
        XCTAssertTrue(alertDialog.exists)
    }
    
    func testInvalidPassword_emailCorrectPasswordWrong() {
        app.launch()
        app.buttons["Login"].tap()
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("MarcoPolo@gmail.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("wrongPassword")
        app.staticTexts["Zaloguj"].tap()
        
        let alertDialog = app.alerts["Error"]
        let alertLabel = "Password is wrong."
        
        alertDialog.waitForExistence(timeout: 5)
        
        XCTAssert(app.alerts.element.staticTexts[alertLabel].exists)
        XCTAssertTrue(alertDialog.exists)
    }
    
    func testInvalidPassword_emailCorrectPasswordNil() {
        
    }
    
    func testCorrectEmailAndPassword() {
        app.launch()
        app.buttons["Login"].tap()
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("MarcoPolo@gmail.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("12345678")
        app.staticTexts["Zaloguj"].tap()
        
        let tabBar = app.tabBars["Tab Bar"]
        let myTests = tabBar.buttons["Moje testy"]
        let menu = tabBar.buttons["Menu"]
        let stats = tabBar.buttons["Stats"]
        
        tabBar.waitForExistence(timeout: 5)
        
        XCTAssertTrue(tabBar.exists)
        XCTAssertTrue(myTests.exists)
        XCTAssertTrue(menu.exists)
        XCTAssertTrue(stats.exists)
    }

}
