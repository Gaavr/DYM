//
//  AddPosterView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 06.02.2026.
//

import SwiftData
import SwiftUI
import PhotosUI

struct AddPosterView: View {
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isPresented: Bool = false
    
    var categories: [Category]
    @State private var choosenCategory: Category? = nil
    @State private var tone: MotivationIntensity = .any
    
    init(categories: [Category]) {
        self.categories = categories
    }
    
    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images,
                photoLibrary: .shared()
            ) {
                BigActionButton(title: "Photo Library", systemImage: "photo.on.rectangle.angled"
                )
            }
           
                        .onChange(of: selectedPhoto) { _, newValue in
                            if newValue != nil {
                                isPresented = true
                            }
                        }
                        .sheet(isPresented: $isPresented) {
                            NavigationStack {
                                Form {
                                    Picker("Message style", selection: $tone) {
                                        ForEach(MotivationIntensity.allCases, id: \.self) { tone in
                                            Text(tone.rawValue).tag(tone)
                                        }
                                    }
            
                                    Picker("Category", selection: $choosenCategory) {
                                        ForEach(categories) { category in
                                            Text(category.name)
                                                .tag(Optional(category)) // важно, если choosenCategory: Category?
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
                                            // save logic here
                                            isPresented = false
                                        }
                                    }
                                }
                            }
                        }
            
            NavigationLink {
                AddQuoteView()
            } label: {
                BigActionButton(title: "Write a quote", systemImage: "quote.bubble")
            }
            
            NavigationLink {
                UnsplashSearchView()
            } label: {
                BigActionButton(title: "Unsplash", systemImage: "square.and.arrow.down")
            }
        }
        .buttonStyle(.plain)
        .navigationTitle(Text("Add poster"))
        .onAppear { print("AddPosterView APPEAR") }
        .onDisappear { print("AddPosterView DISAPPEAR") }
    }
}

struct BigActionButton: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 22, weight: .semibold))

            Text(title)
                .font(.headline)
        }
        .frame(width: 260, height: 80)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
    }
}

#Preview {
    let previewCategories = [
        Category(
            name: "Motivation",
            categoryDescription: "Daily motivation",
            color: .blue,
            icon: "🔥"
        ),
        Category(
            name: "Gym",
            categoryDescription: "Workout posters",
            color: .red,
            icon: "💪"
        )
    ]

    NavigationStack {
        AddPosterView(categories: previewCategories)
    }
}
