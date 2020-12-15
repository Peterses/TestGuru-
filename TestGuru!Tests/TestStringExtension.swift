//
//  TestStringExtension.swift
//  TestGuru!Tests
//
//  Created by Piotr Tocicki on 12/10/2020.
//

import XCTest
@testable import TestGuru_

class TestStringExtension: XCTestCase {

    func testFirstUppercased() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let word = "cancel"
        let expectationResult = "Cancel"
        let result = word.firstUppercased()
    }

}
