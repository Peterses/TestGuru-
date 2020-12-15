//
//  Question.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 15/10/2020.
//

import Foundation

struct QuestionModel: Codable, Equatable {
    
    var name: String
    var answers: [AnswerModel]
    
    public static func ==(lhs: QuestionModel, rhs: QuestionModel) -> Bool{
        return
            lhs.name == rhs.name &&
            lhs.answers == rhs.answers
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case answers
    }
}
