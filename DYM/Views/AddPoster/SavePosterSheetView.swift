//
//  SavePosterSheetView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 24.02.2026.
//

import SwiftUI

struct SavePosterSheetView: View {
    let categories: [Category]
    let imageData: Data?
    let isReady: Bool
    
    @Binding var isPresented: Bool
    @Binding var chosenCategory: Category?
    @Binding var tone: MotivationIntensity
    
    let onSave: (Category, MotivationIntensity) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
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
                Section("Preview") {
                    Group {
                        if let imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 260)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        } else {
                            ContentUnavailableView("No image", systemImage: "photo")
                                .frame(height: 160)
                        }
                    }
                    .frame(maxWidth: .infinity)
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
