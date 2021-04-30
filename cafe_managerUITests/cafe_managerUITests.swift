//
//  cafe_managerUITests.swift
//  cafe_managerUITests
//
//  Created by Supun Sashika on 2021-04-30.
//

import XCTest

class when_login_button_is_pressed: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_should_show_error_when_no_values_in_fields() throws {
    
        let app = XCUIApplication()
        app.launch()

        let loginButton = app.buttons["loginButton"]
        loginButton.tap()
        
        let loginErrorLabel = app.staticTexts["loginErrorLabel"]
        
        XCTAssertEqual("Invalid email format.", loginErrorLabel.label)
    }
    
    func test_should_show_error_when_invalid_credentials() throws {
        
        let app = XCUIApplication()
        app.launch()

        let loginButton = app.buttons["loginButton"]
        
        let loginEmailTextField = app.textFields["loginEmailTextField"]
        loginEmailTextField.tap()
        loginEmailTextField.typeText("admin@gmail.com")
        
        let loginPasswordTextField = app.secureTextFields["loginPasswordTextField"]
        loginPasswordTextField.tap()
        loginPasswordTextField.typeText("1234")
        
        loginButton.tap()
        
        let loginErrorLabel = app.staticTexts["loginErrorLabel"]
        
        XCTAssertEqual("Invalid credentials!", loginErrorLabel.label)
        
    }
    
    func test_should_goto_orders_screen_if_correct_credentials() throws {
        
        let app = XCUIApplication()
        app.launch()

        let loginButton = app.buttons["loginButton"]
        
        let loginEmailTextField = app.textFields["loginEmailTextField"]
        loginEmailTextField.tap()
        loginEmailTextField.typeText("admin@gmail.com")
        
        let loginPasswordTextField = app.secureTextFields["loginPasswordTextField"]
        loginPasswordTextField.tap()
        loginPasswordTextField.typeText("123")
        
        loginButton.tap()
        
        let ordersView = app.otherElements["ordersView"]
        let ordersViewShown = ordersView.waitForExistence(timeout: 5)
        
        XCTAssert(ordersViewShown)
    }
}
