//
//  SettingsView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 18.12.2025.
//

import SwiftData
import StoreKit
import SwiftUI

struct SettingsView: View {
    
    @AppStorage(SettingsKeys.isRandomOrder)
    private var isRandomOrder: Bool = false
    
    @AppStorage(SettingsKeys.motivationIntensity)
    private var toneRaw: String = MotivationIntensity.any.rawValue
    
    @AppStorage(SettingsKeys.darkMode)
    private var darkModeRaw: String = DarkModeSettigns.system.rawValue
    
    @Environment(\.openURL) private var openURL
    @Environment(\.requestReview) private var requestReview
    private let appStoreID = "1234567890"
    @Query private var categories: [Category]
    private let appStoreURL = URL(string: "https://apps.apple.com/app/id6758716185")!
    
    @State private var shareAppItem: ShareItem?
    
    @State private var showResetSettingsConfirm = false
    
    
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
                NavigationLink {
                    ExportDataView()
                } label: {
                    Label("settings.exportData", systemImage: "square.and.arrow.up")
                }
            }
            Section("settings.feedback") {
                Button {
                    if categories.count >= 5 {
                        requestReview() // Apple может не показать, это нормально
                    } else {
                        if let url = URL(string: "https://apps.apple.com/app/id\(appStoreID)?action=write-review") {
                            openURL(url)
                        }
                    }
                } label: {
                    Label("settings.rateApp", systemImage: "star")
                }
                Button {
                    shareAppItem = ShareItem(appStoreURL)
                } label: {
                    Label("settings.shareApp", systemImage: "square.and.arrow.up")
                }
                .sheet(item: $shareAppItem) { item in
                    ShareSheet(items: [item.url]) {
                        shareAppItem = nil
                    }
                }
            }
            Section("settings.support") {
                Button {
                    if let url = SupportMail.url(body: SupportMail.defaultBody()) {
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
