//
//  ContentView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 21.11.2025.
//

import SwiftData
import SwiftUI

struct RootView: View {
    
    @AppStorage(SettingsKeys.didSeedInitialData)
    private var didSeedInitialData = false
    
    @Environment(\.modelContext)
    private var modelContext: ModelContext
    
    enum TabId: Hashable {
        case main, about, settings
    }
    
    @State private var selectedTab: TabId = .main
    @State var showAddSheet: Bool = false
    @Query var categories: [Category]
    @State private var chosenCategory: Category?
    
    @AppStorage(SettingsKeys.rootViewSelectedCategoryId)
    private var selectedCategoryId: String?
    
    @AppStorage(SettingsKeys.darkMode)
    private var themeRaw: String = DarkModeSettigns.system.rawValue

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
                        .labelStyle(.titleAndIcon) //TODO: Костыль?
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
            if !didSeedInitialData {
                seedInitialData(context: modelContext)
                didSeedInitialData = true
            }
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
        guard chosenCategory == nil else { return }

        if let idString = selectedCategoryId,
           let uuid = UUID(uuidString: idString),
           let saved = categories.first(where: { $0.id == uuid }) {
            chosenCategory = saved
        } else {
            chosenCategory = categories.first(where: { $0.name == "Common" }) ?? categories.first
        }
    }
    
    func seedInitialData(context: ModelContext) {
        let category = Category(
            name: "Motivation",
            categoryDescription: "Default motivation posters",
            color: .blue,
            icon: "🔥"
        )
        
        let defaultCategory = Category(
            name: "Common",
            categoryDescription: "Images without specific theme",
            color: .gray,
            icon: "♾️",
            isProtected: true
        )
        
        let imageNames = (1...16).map { "img\($0)" }
        
        for name in imageNames {
            guard
                let uiImage = UIImage(named: name),
                let data = uiImage.pngData()
            else { continue }
            
            let poster = Poster(
                imageData: data,
                motivationIntensity: MotivationIntensity.any,
                posterType: .image,
                category: category
            )
            
            category.posters.append(poster)
            context.insert(poster)
        }
        
        context.insert(category)
        context.insert(defaultCategory)
    }
}

#Preview {
    RootView()
}
