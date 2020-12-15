//
//  CategoriesStats.swift
//  TestGuru!
//
//  Created by Peterses on 13/11/2020.
//

import Foundation

struct CategoriesStatsModel: Codable {
    
    var categoryName: String
    var testsCompleted: Int
    var allGoodAnswers: Int
    var allBadAnswers: Int
    
    enum CodingKeys: String, CodingKey {
        case categoryName
        case testsCompleted
        case allGoodAnswers
        case allBadAnswers
    }
}
