//
//  FullscreenImageView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 04.02.2026.
//

import SwiftUI

struct FullscreenImageView: View {
    let imageName: String
    @State private var showDeleteDialog = false

    var body: some View {
        ZStack {
//            Color.black.ignoresSafeArea()
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .toolbar {
            Button {
                showDeleteDialog = true
                print("Удаляем")
            } label: {
                Image(systemName: "trash")
            }
            .confirmationDialog(
                "Delete photo",
                isPresented: $showDeleteDialog,
                titleVisibility: .visible
            ) {
                Button("Remove from category") {
                    print("Удаляем из категории")
                }

                Button("Delete from device", role: .destructive) {
                    print("Удаляем с устройства")
                }
            }
        }
        
    }
}

#Preview {
    FullscreenImageView(imageName: "img1")
}
