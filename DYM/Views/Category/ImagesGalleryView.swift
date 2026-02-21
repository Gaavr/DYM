//
//  ImagesInCategoryView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 28.01.2026.
//

import SwiftData
import SwiftUI

struct ImagesGalleryView: View {
    
    var currentCategory: Category
    var categories: [Category]
    
    @Query private var posters: [Poster]
    
    init(category: Category, categories: [Category]) {
        self.currentCategory = category
        let categoryID = category.id
        
        _posters = Query(
            filter: #Predicate<Poster> { poster in
                poster.category.id == categoryID
            },
            sort: \Poster.createdAt
        )
        
        self.categories = categories
    }
    
    @Environment(\.editMode) private var editMode
    
    @State var showAddSheet: Bool = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6)
    ]
    
    
    var body: some View {
        NavigationStack {
            if posters.isEmpty {
                ContentUnavailableView {
                    Label("No posters", systemImage: "photo.on.rectangle.angled")
                } description: {
                    Text("Add your first poster")
                } actions: {
                    NavigationLink {
                        AddPosterView(categories: categories)
                    } label: {
                        Label("Add", systemImage: "photo.badge.plus")
                    }
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(posters) { poster in
                            NavigationLink {
                                FullscreenImageView(poster: poster)
                            } label: {
                                poster.image
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(4.0/5.0, contentMode: .fit)
                                    .clipped()
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(.ultraThinMaterial)
                                            .opacity(0.15)
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                    .shadow(radius: 10, y: 6)
                            }
                        }
                    }
                    .padding(10)
                }
            }
        }
        .navigationTitle(currentCategory.name)
        .toolbar {
            if (!posters.isEmpty) {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddPosterView(categories: categories)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
           
        }
//        .onAppear { print("ImagesInCategoryView APPEAR") }
//        .onDisappear { print("ImagesInCategoryView DISAPPEAR") }
    }
    
}

#Preview {
    let catGym = Category(
        name: "Gym",
        categoryDescription: "Description",
        color: .red,
        icon: "💪"
    )

    let catMotivation = Category(
        name: "Motivation",
        categoryDescription: "Daily motivation",
        color: .blue,
        icon: "🔥"
    )

    let all = [catGym, catMotivation]

    return NavigationStack {
        ImagesGalleryView(category: catGym, categories: all)
    }
}
