//
//  AppSettings.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 20.12.2025.
//

import Foundation

struct AppSettings {
    //MARK: Appearance
    var isDarkMode: Bool = false
    
    //MARK: Filtering
    var currentCategory: Category.ID?
    var showOnlyLiked: Bool = false
    
    //MARK: Sensations
    var areHapticsOn: Bool = false
    
    //MARK: Sound
    var isSoundOn: Bool = false
    var volume: Double = 0.5
}
