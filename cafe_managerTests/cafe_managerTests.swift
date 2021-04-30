//
//  cafe_managerTests.swift
//  cafe_managerTests
//
//  Created by Supun Sashika on 2021-04-30.
//

import XCTest
@testable import cafe_manager

class cafe_managerTests: XCTestCase {

    var validation: ValidationService!
    
    override func setUp() {
        super.setUp()
        validation = ValidationService()
    }
    
    override func tearDown() {
        validation = nil
        super.tearDown()
    }
    
    func test_is_valid_email() {
        XCTAssertEqual(validation.isValidEmail("supun@gmail.com"), true)
    }
    
    func test_is_invalid_email() {
        XCTAssertEqual(validation.isValidEmail("supungmail.com"), false)
    }
    
    
    func test_is_email_field_invalid_email() {
        let expectedError = ValidationError.invalidEmailFormat
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validateEmail("supun.com")) {
            thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.localizedDescription, "Invalid email format.")
    }
    
    func test_is_email_field_valid() throws {
        XCTAssertNoThrow(try validation.validateEmail("supun@gmail.com"))
    }
    
    func test_is_email_nil() throws {

        let expectedError = ValidationError.invalidValue
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validateEmail(nil)) {
            thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.localizedDescription, "Invalid value.")
    }
    
    func test_is_password_field_valid() throws {
        XCTAssertNoThrow(try validation.validatePassword("123"))
    }
    
    func test_is_password_nil() throws {

        let expectedError = ValidationError.invalidValue
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validatePassword(nil)) {
            thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
    }

}
