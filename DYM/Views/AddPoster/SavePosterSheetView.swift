//
//  SavePosterSheetView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 24.02.2026.
//


import SwiftUI

struct SavePosterSheetView: View {
    let categories: [Category]
    let isReady: Bool
    
    @Binding var isPresented: Bool
    @Binding var chosenCategory: Category?
    @Binding var tone: MotivationIntensity
    
    let onSave: (Category, MotivationIntensity) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Message style", selection: $tone) {
                    ForEach(MotivationIntensity.allCases, id: \.self) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                
                Picker("Category", selection: $chosenCategory) {
                    ForEach(categories) { c in
                        Text(c.name).tag(Optional(c))
                    }
                }
            }
            .navigationTitle("New poster")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let category = chosenCategory else { return }
                        onSave(category, tone)
                        isPresented = false
                    }
                    .disabled(!isReady || chosenCategory == nil)
                }
            }
        }
    }
}

enum NewPosterMode {
    case image
    case quote
}
