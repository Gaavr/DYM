//
//  SettingsView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 18.12.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(SettingsKeys.isRandomOrder)
    private var isRandomOrder: Bool = false
    
    @AppStorage(SettingsKeys.motivationIntensity)
    private var toneRaw: String = MotivationIntensity.any.rawValue
    
    @AppStorage(SettingsKeys.isDarkMode)
    private var isDarkMode: Bool = false
    
    @AppStorage(SettingsKeys.language)
    private var languageRaw: String = AppLanguage.en.rawValue
    
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
                Section {
                    Picker(selection: $toneRaw) {
                        ForEach(MotivationIntensity.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item.rawValue)
                        }
                    } label: {
                        Label("Message style", systemImage: "slider.horizontal.below.square.and.square.filled")
                    }
                } footer: {
                    Text("Positive focuses on rewards and long-term gains. Negative highlights risks and consequences.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            Section("Apperaance") {
                Toggle(isOn: $isDarkMode) {
                    Label("Dark mode", systemImage: "circle.lefthalf.filled")
                }
            }
            Section("System") {
                Picker(selection: $languageRaw) {
                    ForEach(AppLanguage.allCases, id: \.self) { language in
                        Text(language.rawValue)
                            .tag(language.rawValue)
                    }
                } label: {
                    Label("Language", systemImage: "globe")
                }
                if (DeviceCapabilities.hasActionButton) {
                    Section {
                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                openURL(url)
                            }
                        } label: {
                            Label("Action Button", systemImage: "button.vertical.left.press.fill")
                        }
                    } footer: {
                        Text("""
                        Assign this app to your Action Button to instantly redirect your focus.
                        Go to Settings → Action Button to configure it.
                        """)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    }
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
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    SettingsView()
}
