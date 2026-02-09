//
//  FullscreenImageView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 04.02.2026.
//

import SwiftData
import SwiftUI

struct FullscreenImageView: View {
    let poster: Poster
    @State private var showDeleteAlert = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Category> { $0.isProtected == true })
    private var protectedCategories: [Category]
    private var commonCategory: Category? {
        protectedCategories.first { $0.name == "Common" }
    }

    private var isInCommon: Bool {
        poster.category.name == "Common"
    }

    var body: some View {
        ZStack {
            poster.image
                .resizable()
                .scaledToFit()
        }
        .toolbar {
            Button {
                showDeleteAlert = true
            } label: {
                Image(systemName: "trash")
            }
        }
        .alert("Delete photo?", isPresented: $showDeleteAlert) {

            if !isInCommon {
                Button("Remove from category") {
                    guard let common = commonCategory else { return }
                    poster.category = common
                    dismiss()
                }
            }

            Button("Delete from device", role: .destructive) {
                modelContext.delete(poster)
                dismiss()
            }

            Button("Cancel", role: .cancel) { }

        } message: {
            Text("Choose what you want to do with this photo.")
        }
    }
}
