//
//  AddPosterSheet.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 05.02.2026.
//

import SwiftUI

struct AddPosterSheet: View {

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            AddPosterGridButton(title: "Photo Library", systemImage: "photo.on.rectangle.angled", action: {print("Test")})
            AddPosterGridButton(title: "Write a quote", systemImage: "quote.bubble", action: {print("Test")})
            AddPosterGridButton(title: "Unsplash", systemImage: "square.and.arrow.down", action: {print("Test")})
        }
        .padding()
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

struct AddPosterGridButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .semibold))
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 90)
        }
        .buttonStyle(.glass)
//        .tint(.primary)
    }
}

#Preview {
    AddPosterSheet()
}
