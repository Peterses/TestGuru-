//
//  Category.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 11/11/2020.
//

import Foundation

struct Categories {

    let name: String
    let icon: String
    let imagePath: String
    
    internal init(name: String) {
        
        switch name {
        case "Gry":
            icon = "🎮"
            imagePath = ""
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
            imagePath = ""
        default:
            <#code#>
        }
        
        self.name = name
        self.icon = icon
        self.imagePath = imagePath
    }
    
    
}
