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
    
    @AppStorage(SettingsKeys.darkMode)
    private var darkModeRaw: String = DarkModeSettigns.system.rawValue
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Form {
            Section("settings.content") {
                NavigationLink {
                    ListOfCategoriesView()
                } label: {
                    Label("settings.categories", systemImage: "list.dash")
                }
                Toggle(isOn: $isRandomOrder) {
                    Label("settings.randomOrder", systemImage: "photo")
                }
                Section {
                    Picker(selection: $toneRaw) {
                        ForEach(MotivationIntensity.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item.rawValue)
                        }
                    } label: {
                        Label("settings.messageStyle", systemImage: "slider.horizontal.below.square.and.square.filled")
                    }
                } footer: {
                    Text("settings.messageStyle.footer")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            Section("settings.appearance") {
                Picker(selection: $darkModeRaw) {
                    ForEach(DarkModeSettigns.allCases, id: \.self) { mode in
                        Text(LocalizedStringKey("settings.theme." + "\(mode.rawValue)")).tag(mode.rawValue)
                    }
                } label: {
                    Label("settings.theme", systemImage: "circle.lefthalf.filled")
                }
            }
            if (DeviceCapabilities.hasActionButton) {
                Section {
                    Section {
                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                openURL(url)
                            }
                        } label: {
                            Label("settings.actionButton", systemImage: "button.vertical.left.press.fill")
                        }
                    } footer: {
                        Text("settings.actionButton.footer")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                } header: {
                    Text("settings.system")
                }
            }
            
            Section("settings.data") {
                Button {
                    
                } label: {
                    Label("settings.exportData", systemImage: "square.and.arrow.up.circle")
                }
            }
            Section("settings.feedback") {
                Button {
                    
                } label: {
                    Label("settings.rateApp", systemImage: "star.bubble")
                }
                Button {
                    
                } label: {
                    Label("settings.shareApp", systemImage: "square.and.arrow.up")
                }
            }
            Section("settings.support") {
                //TODO: добавить шаблон для сообщения
                Button {
                    if let url = URL(string: "mailto:gavrjob@gmail.com") {
                        openURL(url)
                    }
                } label: {
                    Label("settings.contactSupport", systemImage: "envelope")
                }

                Button {
                    // buy coffee
                } label: {
                    Label("settings.buyCoffee", systemImage: "cup.and.saucer")
                }
            }
            Section("settings.warning") {
                Button {
                    
                } label: {
                    Label("settings.resetSettings", systemImage: "arrow.counterclockwise")
                }
                Button {
                    
                } label: {
                    Label("settings.deleteAllData", systemImage: "trash")
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
