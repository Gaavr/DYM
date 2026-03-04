//
//  ContentView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 21.11.2025.
//

import SwiftData
import SwiftUI

struct RootView: View {
    
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    @Query var categories: [Category]
    
    @AppStorage(SettingsKeys.didSeedInitialData) private var didSeedInitialData = false
    @AppStorage(SettingsKeys.rootViewSelectedCategoryId) private var selectedCategoryId: String?
    @AppStorage(SettingsKeys.darkMode) private var themeRaw: String = DarkModeSettigns.system.rawValue
    
    @State private var selectedTab: TabId = .main
    @State var showAddSheet: Bool = false
    @State private var chosenCategory: Category?
    
    let seeder = DatabaseSeeder()
    enum TabId: Hashable {
        case main, about, settings
    }
    private var theme: DarkModeSettigns {
        DarkModeSettigns(rawValue: themeRaw) ?? .system
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                Tab("About", systemImage: "info.circle", value: TabId.about) { AboutView() }
                Tab("DYM", systemImage: "brain", value: TabId.main) {
                    MainView(category: $chosenCategory)
                        .id(chosenCategory?.id)
                }
                Tab("Settings", systemImage: "gearshape.fill", value: TabId.settings) {
                    SettingsView()
                        .labelStyle(.titleAndIcon)
                }
            }
            .toolbar {
                if (selectedTab == .main) {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            ForEach(categories) { category in
                                Button {
                                    chosenCategory = category
                                    selectedCategoryId = category.id.uuidString
                                } label: {
                                    Text(category.name)
                                }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Text(chosenCategory?.name ?? "Category")
                                    .lineLimit(1)
                                Image(systemName: "chevron.down")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    ToolbarItem {
                        NavigationLink {
                            AddPosterView(categories: categories, defaultCategory: chosenCategory)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                }
            }
            .labelStyle(.iconOnly)
            
        }
        .onAppear {
            seeder.seed(into: modelContext)
            restoreChosenCategoryIfNeeded()
        }
        .onChange(of: categories.count) {
            restoreChosenCategoryIfNeeded()
        }
        .preferredColorScheme(
            theme == .system ? nil : (theme == .dark ? .dark : .light)
        )
    }
    
    private func restoreChosenCategoryIfNeeded() {
        if let chosen = chosenCategory,
           categories.contains(where: { $0.id == chosen.id }) {
            return
        } else if let idString = selectedCategoryId,
                  let uuid = UUID(uuidString: idString),
                  let saved = categories.first(where: { $0.id == uuid }) {
            chosenCategory = saved
        } else if let common = categories.first(where: { $0.isProtected }) {
            chosenCategory = common
            selectedCategoryId = common.id.uuidString
        } else {
            chosenCategory = categories.first
            selectedCategoryId = chosenCategory?.id.uuidString
        }
    }
}

#Preview {
    RootView()
}
