//
//  StatsModel.swift
//  TestGuru!
//
//  Created by Peterses on 13/11/2020.
//

import Foundation

struct StatsModel: Codable {
    
    let user: UserModel
    // remember to update!
    var allTestsCompleted: Int
    var statsByCategory: [CategoriesStatsModel]
    
    enum CodingKeys: String, CodingKey {
        case user
        case allTestsCompleted
        case statsByCategory
    }
}
