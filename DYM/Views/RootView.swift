//
//  ContentView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 21.11.2025.
//

import SwiftData
import SwiftUI

struct RootView: View {
    
    @AppStorage("didSeedMotivation") private var didSeedMotivation = false
    @Environment(\.modelContext)
    private var modelContext: ModelContext
    
    enum TabId: Hashable {
        case main, about, settings
    }
    
    @State private var selectedTab: TabId = .main
    
    @State var showAddSheet: Bool = false
    @Query var categories: [Category]
    @State private var chosenCategory: Category?
    
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
                            AddPosterView(categories: categories)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                }
            }
            .labelStyle(.iconOnly)
            
        }
        .onAppear {
            if !didSeedMotivation {
                seedMotivationCategory(context: modelContext)
                didSeedMotivation = true
            }
            if chosenCategory == nil {
                chosenCategory =
                categories.first(where: { $0.name == "Common" })
                ?? categories.first
            }
        }
        .preferredColorScheme(.light)
    }
    
    func seedMotivationCategory(context: ModelContext) {
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
