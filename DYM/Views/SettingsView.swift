//
//  SettingsView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 18.12.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var isRandomOrder: Bool = false
    @State private var isDarkMode: Bool = false
    @State private var language: AppLanguage = .en
    
    var body: some View {
        Form {
            Section("Content") {
                NavigationLink {
                    CategoryView()
                } label: {
                    Label("Categories settings", systemImage: "list.dash")
                }
                Toggle(isOn: $isRandomOrder) {
                    Label("Random cards order", systemImage: "photo")
                    
                }
                // Motivation intensity (позитивная/негативная/все вместе)
                
                
            }
            Section("Apperaance") {
             
                
                Toggle(isOn: $isDarkMode) {
                    Label("Dark mode", systemImage: "circle.lefthalf.filled")
                }
            }
            Section("System") {
                
            }
            Section("Warning") {
                //Delete data
            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    SettingsView()
}
