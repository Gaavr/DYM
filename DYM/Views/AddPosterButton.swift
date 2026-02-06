//
//  AddPosterButton.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 05.02.2026.
//

import SwiftUI

// MARK: - AddPosterAction

enum AddPosterAction: String, CaseIterable {
    case photoLibrary = "Load from Photo Library"
    case quote = "Write a quote"
    case unsplash = "From Unsplash"
}

// MARK: - AddPosterButton

struct AddPosterButton: View {
    let onPick: (AddPosterAction) -> Void
    @State private var showDialog = false

    var body: some View {
        Button {
            showDialog = true
        } label: {
            Image(systemName: "plus")
        }
        .confirmationDialog(
            "Add poster",
            isPresented: $showDialog,
            titleVisibility: .visible
        ) {
            ForEach(AddPosterAction.allCases, id: \.self) { action in
                Button(action.rawValue) {
                    onPick(action)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AddPosterButton { action in
        print(action)
    }
}
