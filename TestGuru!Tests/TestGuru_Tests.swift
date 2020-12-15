//
//  TestGuru_Tests.swift
//  TestGuru!Tests
//
//  Created by Piotr Tocicki on 12/10/2020.
//

import XCTest
//import Firebase

@testable import TestGuru_

class TestGuru_Tests: XCTestCase {

    var dbManager: DbManager!
//    let db = Firestore.firestore()
    
    
    
    func test_WhenTestIsNotNilAndSaveTestIsCalled() {
        // given
        let test = TestModel(id: nil, name: "Test", category: "Test", description: "Test", difficultyLevel: "test", rating: 5.0, ratingsCounter: 4, time: 6, popularity: 4, owner: UserModel(email: "test@test.com"))
        let exp = self.expectation(description: "Waiting for async operation")

        // when
        dbManager.saveTest(test: test) { (isSuccess) in
            if isSuccess {
//                self.db.collection("tests")
//                    .whereField("name", isEqualTo: "Test")
//                    .whereField("category", isEqualTo: "Test")
//                    .whereField("description", isEqualTo: "Test")
//                    .whereField("difficultyLevel", isEqualTo: "test")
//                    .whereField("rating", isEqualTo: "5.0")
//                    .getDocuments { (document, error) in
//                        if let doc = document {
//                            XCTAssertNotNil(doc)
//                            exp.fulfill()
//                        } else {
//                            XCTFail()
//                        }
//                    }
                XCTFail()

            } else {
                XCTFail()
            }
        }

        self.waitForExpectations(timeout: 10, handler: nil)

        // then
    }
}
