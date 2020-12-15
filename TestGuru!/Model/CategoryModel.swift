//
//  CategoryModel.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 15/10/2020.
//

import Foundation
import CodableFirebase

struct CategoryModel: Codable {
    
    let name: String
    let icon: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case icon
        case image
    }
}
