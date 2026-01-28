//
//  AddCategoryView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 26.01.2026.
//

import SwiftUI
import SwiftData

struct CategoryDetailView: View {

    let category: Category?
    
    init(category: Category? = nil) {
        self.category = category
    }
    
    @State private var name: String = ""
    @State private var desctiption: String = ""
    @State private var color: Color = .gray
    @State private var icon: String = ""
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section {
                CategoryItemInListView(category: Category(name: name, categoryDescription: desctiption, color: color, icon: icon))
            }
            Section {
                TextField("Name", text: $name)
                TextField("Description", text: $desctiption)
                ColorPicker("Color", selection: $color)
                TextField("Icon", text: $icon)
            }
            Section {
                Button {
                    if let category {
                        category.name = name
                        category.categoryDescription = desctiption
                        category.color = color.toString()
                        category.icon = icon
                    } else {
                        let newCategory = Category(
                            name: name,
                            categoryDescription: desctiption,
                            color: color,
                            icon: icon
                        )
                        modelContext.insert(newCategory)
                    }
                    dismiss()
                } label: {
                    Text(category == nil ? "Add category" : "Save")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.black)
                }
                .disabled(name.isEmpty)
            }
        }
        //TODO: КУСОР РЕДАКТИРОВАНИЯ ПРОВЕРИТЬ
        .onAppear {
            guard let category else { return }
            name = category.name
            desctiption = category.categoryDescription
            color = category.getColor()
            icon = category.icon
        }
        
    }
}

#Preview {
    CategoryDetailView()
}
