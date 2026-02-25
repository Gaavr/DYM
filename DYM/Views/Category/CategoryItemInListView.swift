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
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(category.getColor())
                    .frame(width: 32, height: 32)

                Text(category.icon)
                    .font(.system(size: 16, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(category.name)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                if !category.categoryDescription.isEmpty {
                    Text(category.categoryDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .contentShape(Rectangle())
    }
}

#Preview {
    CategoryItemInListView(category: Category(name: "Gym", categoryDescription: "Мотивация ходить в зал", color: .blue, icon: "🏋️‍♀️"))
}
