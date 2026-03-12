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
    
    @Environment(\.openURL) private var openURL
    @Environment(\.requestReview) private var requestReview
    @Environment(\.modelContext) private var modelContext
    
    @Query private var categories: [Category]
    
    @AppStorage(SettingsKeys.isRandomOrder) private var isRandomOrder: Bool = false
    @AppStorage(SettingsKeys.motivationIntensity) private var toneRaw: String = MotivationIntensity.any.rawValue
    @AppStorage(SettingsKeys.darkMode) private var darkModeRaw: String = DarkModeSettigns.system.rawValue
    
    @State private var shareAppItem: ShareItem?
    @State private var showResetSettingsAlert = false
    @State private var showDeleteAllDataAlert = false
    @State private var deleteAllDataError: String?
    @State private var showTipError = false
    @State private var showTipsSheet = false
    
    var body: some View {
        Form {
            // MARK: -Content
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
            // MARK: -Appearance
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
            // MARK: -Data
            Section("settings.data") {
                NavigationLink {
                    ExportDataView()
                } label: {
                    Label("settings.exportData", systemImage: "square.and.arrow.up")
                }
            }
            // MARK: -Feedback
            Section("settings.feedback") {
                Button {
                    if categories.count >= 5 {
                        requestReview() // Apple может не показать, это нормально
                    } else {
                        if let url = URL(string: AppConstants.appStoreAppReviewURL) {
                            openURL(url)
                        }
                    }
                } label: {
                    Label("settings.rateApp", systemImage: "star")
                }
                Button {
                    if let url = URL(string: AppConstants.appStoreAppURL) {
                        shareAppItem = ShareItem(url)
                    } else {
                        print("Invalid App Store URL")
                    }
                } label: {
                    Label("settings.shareApp", systemImage: "square.and.arrow.up")
                }
            }
            //MARK: -Support
            Section("settings.support") {
                Button {
                    if let url = SupportMail.url(body: SupportMail.defaultBody()) {
                        openURL(url)
                    }
                } label: {
                    Label("settings.contactSupport", systemImage: "envelope")
                }
            }
            
            // MARK: -Warning
            Section("settings.warning") {
                Button {
                    showResetSettingsAlert = true
                } label: {
                    Label("settings.resetSettings", systemImage: "arrow.counterclockwise")
                }
                Button {
                    showDeleteAllDataAlert = true
                } label: {
                    Label("settings.deleteAllData", systemImage: "trash")
                }
                .font(.headline)
                .foregroundStyle(.red)
            }
            .alert("settings.resetSettings.alert.title", isPresented: $showResetSettingsAlert) {
                Button("common.cancel", role: .cancel) { }
                Button("settings.resetSettings.alert.action", role: .destructive) {
                    resetSettings()
                }
            } message: {
                Text("settings.resetSettings.alert.message")
            }
            .alert("settings.deleteAllData.alert.title", isPresented: $showDeleteAllDataAlert) {
                Button("common.cancel", role: .cancel) { }
                Button("settings.deleteAllData.alert.action", role: .destructive) {
                    deleteAllData()
                }
            } message: {
                Text("settings.deleteAllData.alert.message")
            }
            .alert("settings.deleteAllData.alert.failed.title", isPresented: Binding(
                get: { deleteAllDataError != nil },
                set: { if !$0 { deleteAllDataError = nil } }
            )) {
                Button("common.ok") { deleteAllDataError = nil }
            } message: {
                Text(deleteAllDataError ?? "")
            }
        }
        .foregroundStyle(.primary)
        .sheet(item: $shareAppItem) { item in
            ShareSheet(items: [item.url]) {
                shareAppItem = nil
            }
        }
    }
    
    private func resetSettings() {
        isRandomOrder = false
        toneRaw = MotivationIntensity.any.rawValue
        darkModeRaw = DarkModeSettigns.system.rawValue
    }
    
    private func deleteAllData() {
        do {
            // 1) delete all posters
            let posters = try modelContext.fetch(FetchDescriptor<Poster>())
            posters.forEach { modelContext.delete($0) }
            
            // 2) delete all categories except protected
            let categoriesToDelete = try modelContext.fetch(
                FetchDescriptor<Category>(
                    predicate: #Predicate { $0.isProtected == false }
                )
            )
            categoriesToDelete.forEach { modelContext.delete($0) }
            
            try modelContext.save()
        } catch {
            deleteAllDataError = String(describing: error)
        }
    }
}

#Preview {
    SettingsView()
}
