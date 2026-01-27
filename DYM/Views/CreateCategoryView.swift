//
//  AddCategoryView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 26.01.2026.
//

import SwiftUI

struct CreateCategoryView: View {
    
    @State private var name = ""
    @State private var categoryDescription = ""
    @State private var color: Color = .blue
    @State private var icon: String = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Description", text: $categoryDescription)
                ColorPicker("Color", selection: $color)
                TextField("Icon", text: $icon)
            }
            Section {
                Button {
                    
                } label: {
                    Text("Create category")
                }
            }
        }
        
    }
}

#Preview {
    CreateCategoryView()
}
