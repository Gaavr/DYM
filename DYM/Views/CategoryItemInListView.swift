//
//  CategoryItemInListView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 27.01.2026.
//

import SwiftUI

struct CategoryItemInListView: View {
    
    var name: String = ""
    var description: String = ""
    var color: Color = .blue
    var icon: String = ""
    
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 17)
                    .fill(color)
                Text(icon)
                    .font(.largeTitle)
            }
            .aspectRatio(1, contentMode: .fit)
            VStack {
                Text(name)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.black)
                    .font(.headline)
                Text(description)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            
        }
        .frame(height: 50)
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(color, lineWidth: 3)
            
        )
        .padding()
        
    }
}

#Preview {
    CategoryItemInListView(name: "Gym", description: "Мотивация ходить в зал", color: .blue, icon: "🏋️‍♀️")
}
