//
//  CategoryItemInListView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 27.01.2026.
//

import SwiftUI

struct CategoryItemInListView: View {
    
    let category: Category
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 17)
                    .fill(category.getColor())
                Text(category.icon)
                    .font(.largeTitle)
            }
            .aspectRatio(1, contentMode: .fit)
            VStack {
                Text(category.name)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.black)
                    .font(.headline)
                Text(category.categoryDescription)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color(category.getColor()), lineWidth: 3)
            
        )
    }
}

#Preview {
    CategoryItemInListView(category: Category(name: "Gym", categoryDescription: "Мотивация ходить в зал", color: .blue, icon: "🏋️‍♀️"))
}
