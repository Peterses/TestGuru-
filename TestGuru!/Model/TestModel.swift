//
//  Test.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 25/09/2020.
//

import Foundation

struct TestModel: Codable {

    // MARK: - Properties
    var id: String?
    let name: String
    let category: String
    let description: String?
    let difficultyLevel: String
    let rating: Double
    let ratingsCounter: Int
    let time: Int
    let popularity: Int
    var questions: [QuestionModel]
    let owner: UserModel
    
    // TODO: - to delete
    init(name: String, description: String?, difficultyLevel: String, rating: Double = 0.0, time: Int, popularity: Int = 0, questions: [QuestionModel] = [], owner: UserModel) {
        self.name = name
        self.category = "asdasd"
        self.description = description
        self.difficultyLevel = difficultyLevel
        self.rating = rating
        self.ratingsCounter = 0
        self.time = time
        self.popularity = popularity
        self.questions = questions
        self.owner = owner
    }
    
    init(id: String?, name: String, category: String, description: String?, difficultyLevel: String, rating: Double, ratingsCounter: Int, time: Int, popularity: Int, questions: [QuestionModel] = [], owner: UserModel) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.difficultyLevel = difficultyLevel
        self.rating = rating
        self.ratingsCounter = ratingsCounter
        self.time = time
        self.popularity = popularity
        self.questions = questions
        self.owner = owner
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case category
        case description
        case difficultyLevel
        case rating
        case ratingsCounter
        case time
        case popularity
        case questions
        case owner
    }
}
