//
//  Category.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 11/11/2020.
//

import Foundation

struct Category {

    let name: String
    let icon: String
    let imagePath: String
    
    init(name: String) {
        
        self.name = name
        
        switch name {
        case "Gry":
            icon = "🎮"
            imagePath = "games"
        case "Informatyka":
            icon = "💻"
            imagePath = ""
        case "Geografia":
            icon = "🌍"
            imagePath = "geography"
        case "Literatura":
            icon = "📚"
            imagePath = "literature"
        case "Sport":
            icon = "⚽️"
            imagePath = "sport"
        default:
            icon = ""
            imagePath = ""
        }
    }
}
