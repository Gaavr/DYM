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
    @State private var showToneDialog = false
    @State private var tone: MotivationIntensity = .any
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Form {
            Section("Content") {
                NavigationLink {
                    ListOfCategoriesView()
                } label: {
                    Label("Categories", systemImage: "list.dash")
                }
                Toggle(isOn: $isRandomOrder) {
                    Label("Random cards order", systemImage: "photo")
                }
                Picker(selection: $tone) {
                    ForEach(MotivationIntensity.allCases, id: \.self) { tone in
                        Text(tone.rawValue)
                    }
                } label: {
                    Label("Message style", systemImage: "slider.horizontal.below.square.and.square.filled")
                }
            }
            Section("Apperaance") {
                Toggle(isOn: $isDarkMode) {
                    Label("Dark mode", systemImage: "circle.lefthalf.filled")
                }
            }
            Section("System") {
                Picker(selection: $language) {
                    ForEach(AppLanguage.allCases, id: \.self) { language in
                        Text(language.rawValue)
                    }
                } label: {
                    Label("Language", systemImage: "globe")
                }
                Button {
                    openURL(URL(string: UIApplication.openDefaultApplicationsSettingsURLString)!)
                } label: {
                    Label("Action Button", systemImage: "button.vertical.left.press.fill")
                }
            }
            Section("Data") {
                Button {
                    
                } label: {
                    Label("Export data", systemImage: "square.and.arrow.up.circle")
                }
            }
            Section("Feedback") {
                Button {
                    
                } label: {
                    Label("Rate app", systemImage: "star.bubble")
                }
                
                Button {
                    
                } label: {
                    Label("Share app", systemImage: "square.and.arrow.up")
                }
            }
            Section("Support") {
                Button {
                   
                } label: {
                    Label("Buy me a coffee", systemImage: "cup.and.saucer")
                }
            }
            Section("Warning") {
                Button {
                    
                } label: {
                    Label("Reset Settings", systemImage: "arrow.counterclockwise")
                }
                
                Button {
                    
                } label: {
                    Label("Delete all data", systemImage: "trash")
                }
                .font(.headline)
                .foregroundStyle(.red)
            }
            
            
            //TODO: Настройка по ACtion Button еще
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    SettingsView()
}
