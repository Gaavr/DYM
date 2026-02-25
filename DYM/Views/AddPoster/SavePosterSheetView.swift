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
                    Picker("common.messageStyle", selection: $tone) {
                        ForEach(MotivationIntensity.allCases, id: \.self) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    Picker("category.category", selection: $chosenCategory) {
                        ForEach(categories) { c in
                            Text(c.name).tag(Optional(c))
                        }
                    }
                }
                Section("quote.preview") {
                    Group {
                        if let imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 260)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        } else {
                            ContentUnavailableView("poster.noImage", systemImage: "photo")
                                .frame(height: 160)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("poster.new")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel") { isPresented = false }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.save") {
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
