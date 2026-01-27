//
//  CategoryView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 18.12.2025.
//

import SwiftUI

struct CategoryView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
        }
        .toolbar {
            ToolbarItem {
                NavigationLink(destination: CreateCategoryView()) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    CategoryView()
}
