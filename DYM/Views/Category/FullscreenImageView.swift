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
        .alert("poster.delete", isPresented: $showDeleteAlert) {

            if !isInCommon {
                Button("category.remove") {
                    guard let common = commonCategory else { return }
                    poster.category = common
                    dismiss()
                }
            }

            Button("category.delete", role: .destructive) {
                modelContext.delete(poster)
                dismiss()
            }

            Button("common.cancel", role: .cancel) { }

        } message: {
            Text("poster.chooseWhatDo")
        }
    }
}
