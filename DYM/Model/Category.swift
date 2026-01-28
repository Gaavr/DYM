//
//  Untitled.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 20.12.2025.
//

import SwiftData
import SwiftUI

@Model
class Category {
    var id: UUID
    var name: String
    var categoryDescription: String
    var color: String
    var icon: String
    var created: Date
    
    init(name: String, categoryDescription: String, color: Color, icon: String) {
        self.id = UUID()
        self.name = name
        self.categoryDescription = categoryDescription
        self.color = color.toString()
        self.icon = icon
        self.created = Date.now
    }
    
    func getColor() -> Color {
        let parts = color
            .split(separator: ",")
            .compactMap(Double.init)
        + [0, 0, 0, 1]
        
        return Color(
            red: parts[0],
            green: parts[1],
            blue: parts[2],
            opacity: parts[3]
        )
    }
}
