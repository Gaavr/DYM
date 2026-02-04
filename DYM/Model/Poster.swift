//
//  Image.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 20.12.2025.
//

import SwiftData
import Foundation

@Model
class Poster {
    var id: UUID
    var name: String
    @Attribute(.externalStorage)
    var imageData: Data?
    var posterType: PosterType
    var category: Category
    var createdAt: Date

    init(
        name: String,
        imageData: Data?,
        posterType: PosterType,
        category: Category,
        id: UUID = UUID(),
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.imageData = imageData
        self.posterType = posterType
        self.category = category
        self.createdAt = createdAt
    }
}
