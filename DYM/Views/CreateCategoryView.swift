//
//  AddCategoryView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 26.01.2026.
//

import SwiftUI

struct CreateCategoryView: View {
    
    @State private var name: String = ""
    @State private var desctiption: String = ""
    @State private var color: Color = .blue
    @State private var icon: String = ""
    
    var body: some View {
        Form {
            Section {
                CategoryItemInListView(name: name, description: desctiption, color: color, icon: icon)
            }
            Section {
                TextField("Name", text: $name)
                TextField("Description", text: $desctiption)
                ColorPicker("Color", selection: $color)
                TextField("Icon", text: $icon)
            }
            Section {
                Button {
                    print("Создаем категорию")
                } label: {
                    Text("Create category")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.black)
                }
            }
        }
        
    }
}

#Preview {
    CreateCategoryView()
}
