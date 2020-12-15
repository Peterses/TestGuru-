//
//  UITest_CreateTestView.swift
//  TestGuru!UITests
//
//  Created by Peterses on 02/12/2020.
//

import XCTest

class UITest_CreateTestView: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "CreateTest")
        UIApplication.shared.keyWindow?.rootViewController = controller
    }
    
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        
        
        
//        app/*@START_MENU_TOKEN@*/.staticTexts["Login"]/*[[".buttons[\"Login\"].staticTexts[\"Login\"]",".staticTexts[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//        let emailTextField = app.textFields["Email"]
//        emailTextField.tap()
//        emailTextField.typeText("MarcoPolo@gmail.com")
//
//        let passwordSecureTextField = app.secureTextFields["Password"]
//        passwordSecureTextField.tap()
//        passwordSecureTextField.typeText("12345678")
//
//        let zalogujButton = app.buttons["Zaloguj"]
//        zalogujButton.tap()
        
//        let okButton = app.alerts["Error"].scrollViews.otherElements.buttons["OK"]
//        okButton.tap()
//        emailTextField.tap()
//        zalogujButton.tap()
//        app.tabBars["Tab Bar"].buttons["Moje testy"].tap()
//
//        let utwRzTestButton = app.buttons["Utwórz test"]
//        utwRzTestButton.tap()
//        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
//        utwRzTestButton.staticTexts["Utwórz test"].tap()
//        okButton.tap()
//
//
        
//        let alertDialog = app.alerts["Error"]
//        let alertLabel = "Email or password are missing."
//
//        XCTAssertTrue(alertDialog.exists)
        
    }

}
