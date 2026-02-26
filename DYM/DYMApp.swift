//
//  DYMApp.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 21.11.2025.
//

import SwiftData
import SwiftUI

@main
struct DYMApp: App {
    @StateObject private var tipStore = TipStore()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(tipStore)
                .task {
                    tipStore.startListening()
                }
        }
        .modelContainer(for: Category.self)
    }
}
