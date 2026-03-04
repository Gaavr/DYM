//
//  CategorySeedData.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 02.03.2026.
//


import SwiftData
import UIKit
import SwiftUI

struct DatabaseSeeder {
    
    private let seededKey = "isDatabaseSeeded"
    
    private var currentLanguage: String {
        Locale.preferredLanguages.first
            .flatMap { Locale(identifier: $0).language.languageCode?.identifier }
        ?? "en"
    }
    
    func seed(into context: ModelContext) {
        guard !UserDefaults.standard.bool(forKey: seededKey) else {
            print("DatabaseSeeder already executed")
            return
        }
        guard let seedData = loadSeedFile() else {
            print("DatabaseSeeder: failed to load categoriesSeed.json")
            return
        }
        print("DatabaseSeeder: device language is \(currentLanguage)")
        for categoryData in seedData.categories {
            createCategory(from: categoryData, in: context)
        }
        UserDefaults.standard.set(true, forKey: seededKey)
        print("DatabaseSeeder: done (\(seedData.categories.count) categories)")
    }
    
    private func loadSeedFile() -> SeedFileData? {
        guard let fileURL = Bundle.main.url(forResource: "categoriesSeed", withExtension: "json") else {
            print("categoriesSeed.json was not found in the app bundle")
            return nil
        }
        guard let rawData = try? Data(contentsOf: fileURL) else {
            print("Failed to read categoriesSeed.json")
            return nil
        }
        do {
            return try JSONDecoder().decode(SeedFileData.self, from: rawData)
        } catch {
            print("JSON parsing error: \(error)")
            return nil
        }
    }
    
    private func createCategory(from data: CategorySeedData, in context: ModelContext) {
        let category = Category(
            name: NSLocalizedString(data.nameKey, comment: ""),
            categoryDescription: NSLocalizedString(data.descKey, comment: ""),
            color: data.color.toColor(),
            icon: data.icon,
            isProtected: data.isProtected
        )
        
        // Filter posters by device language
        let filteredPosters = data.posters.filter { posterData in
            shouldIncludePoster(posterData)
        }
        
        for posterData in filteredPosters {
            guard let uiImage = UIImage(named: posterData.imageName) else {
                print("Image '\(posterData.imageName)' was not found. Skipping.")
                continue
            }
            guard let imageData = uiImage.pngData() else {
                print("Failed to convert '\(posterData.imageName)' to PNG. Skipping.")
                continue
            }
            
            let poster = Poster(
                imageData: imageData,
                motivationIntensity: posterData.intensity.toMotivationIntensity(),
                posterType: .image,
                category: category
            )
            
            category.posters.append(poster)
            context.insert(poster)
        }
        
        context.insert(category)
        print("Category '\(data.nameKey)': added \(category.posters.count) posters")
    }
    
    private func shouldIncludePoster(_ poster: PosterSeedData) -> Bool {
        poster.language == "xx" || poster.language == currentLanguage
    }
    
    //для дебага
    func resetSeedFlag() {
        UserDefaults.standard.removeObject(forKey: seededKey)
        print("DatabaseSeeder: seed flag reset")
    }
}

// MARK: - JSON Models
struct PosterSeedData: Decodable {
    let imageName: String
    let intensity: String
    let language: String
}

struct CategorySeedData: Decodable {
    let seedToken: String
    let nameKey: String
    let descKey: String
    let color: String
    let icon: String
    let isProtected: Bool
    let posters: [PosterSeedData]
}

struct SeedFileData: Decodable {
    let categories: [CategorySeedData]
}
