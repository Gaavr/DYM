//
//  Untitled.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 20.12.2025.
//

import Foundation
import SwiftData
import SwiftUI
//
//@Model
class Category {
    var id: UUID = UUID()
    var name: String
    var categoryDescription: String
    var color: Color
    var icon: String
    var created: Date
    
    init(id: UUID, name: String, categoryDesctiprion: String, color: Color, icon: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.categoryDescription = categoryDesctiprion
        self.color = color
        self.icon = icon
        self.created = createdAt
    }
}
