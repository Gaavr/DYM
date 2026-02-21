//
//  ContentView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 20.01.2026.
//

import SwiftUI
import SwiftData


struct MainView: View {
    @Binding var category: Category?

    @Query private var posters: [Poster]

    init(category: Binding<Category?>) {
        self._category = category
        let selectedID = category.wrappedValue?.id

        _posters = Query(
            filter: #Predicate<Poster> { poster in
                selectedID != nil && poster.category.id == selectedID!
            }
        )
    }

    var body: some View {
        //TODO: Сделать бесконечный скролл
        Group {
            if category == nil {
                ContentUnavailableView("Choose a category", systemImage: "square.grid.2x2")
            } else if posters.isEmpty {
                ContentUnavailableView("No posters", systemImage: "photo")
            } else {
                TabView {
                    ForEach(posters) { poster in
                        poster.image
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
            }
        }
    }
}

#Preview {
    let common = Category(
        name: "Common",
        categoryDescription: "Default category",
        color: .gray,
        icon: "♾️",
        isProtected: true
    )
    
    MainView(category: .constant(common))
}
