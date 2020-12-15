//
//  Answer.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 15/10/2020.
//

import Foundation

struct AnswerModel: Codable, Equatable {

    let name: String
    let isCorrect: Bool
    
    public static func ==(lhs: AnswerModel, rhs: AnswerModel) -> Bool{
        return
            lhs.name == rhs.name &&
            lhs.isCorrect == rhs.isCorrect
    }

    enum CodingKeys: String, CodingKey {
        case name
        case isCorrect
    }
}
