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
    var motivationIntensity: MotivationIntensity
    var posterType: PosterType
    var category: Category
    var createdAt: Date

    init(
        id: UUID = UUID(),
        imageData: Data?,
        motivationIntensity: MotivationIntensity,
        posterType: PosterType,
        category: Category,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = "Poster_\(Date.now.formatted(.iso8601))_\(UUID().uuidString)"
        self.imageData = imageData
        self.motivationIntensity = motivationIntensity
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
