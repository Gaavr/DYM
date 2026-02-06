//
//  Image.swift//  DYM
//
//  Created by Andrei Gavrilenko on 20.12.2025.
//

import SwiftData
import Foundation
import SwiftUI

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

extension Poster {
    var image: Image {
        if let data = imageData,
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "photo")
        }
    }
}
