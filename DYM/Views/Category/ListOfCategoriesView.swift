//
//  CategoryView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 18.12.2025.
//

import SwiftData
import SwiftUI

struct ListOfCategoriesView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    //TODO: Сделать сортировку и вынести дефолтную категорию вниз
    @Query var categories: [Category]
    @State private var selectedCategory: Category?
    @State private var showProtectedAlert = false
    
    var body: some View {
        VStack {
            List {
                ForEach(categories) { category in
                    NavigationLink {
                        ImagesGalleryView(category: category, categories: categories)
                    } label: {
                        CategoryItemInListView(category: category)
                    }
                    .swipeActions(edge: .trailing) {
                        if !category.isProtected {
                            Button(role: .destructive) {
                                deleteCategory(category)
                            } label: {
                                Label("common.delete", systemImage: "trash")
                            }

                            NavigationLink {
                                CategoryDetailView(category: category)
                            } label: {
                                Label("common.edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .listStyle(.plain)
        }
        .navigationBarTitle("settings.categories")
        .alert("alert.nelzya", isPresented: $showProtectedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You can't delete 'Common' category")
        }
        .toolbar {
            ToolbarItem {
                NavigationLink(destination: CategoryDetailView()) {
                    Image(systemName: "plus")
                }
            }
        } //TODO: Ток на текст нажимается при переходе к изображениям
        .navigationDestination(item: $selectedCategory) { category in
            ImagesGalleryView(category: category, categories: categories)
        }
    }
    
    private func deleteCategory(_ category: Category) {
        if (category.isProtected) {
            showProtectedAlert = true
            return
        }
        modelContext.delete(category)
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Category.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    let context = container.mainContext
    
    context.insert(
        Category(
            name: "Gym",
            categoryDescription: "Ходить в зал",
            color: .blue,
            icon: "🏋️‍♀️"
        )
    )
    
    context.insert(
        Category(
            name: "Focus",
            categoryDescription: "Работа без отвлечений",
            color: .purple,
            icon: "🧠"
        )
    )
    
    return NavigationStack {
        ListOfCategoriesView()
    }
    .modelContainer(container)
}
