//
//  Image.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 20.12.2025.
//

import Foundation

struct Poster: Identifiable {
    
    let id: UUID = UUID()
    let name: String
    var url: URL
    var posterType: PosterType
    
    var categoryId: Category.ID?
    var isLiked: Bool = false
    
    let createdAt: Date
    var shownCount: Int = 0
    var lastShownAt: Date?
}
