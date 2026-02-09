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
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var imageData: Data?
    var isSheetPresented: Binding<Bool> {
        Binding(
            get: {
                return selectedPhoto != nil
            },
            set: { newValue in
                if newValue == false {
                    selectedPhoto = nil
                }
            }
        )
    }
    
    var categories: [Category]
    @State private var choosenCategory: Category?
    @State private var tone: MotivationIntensity = .any
    
    @Environment(\.modelContext) private var modelContext
    
    init(categories: [Category]) {
        self.categories = categories
        _choosenCategory = State(
                initialValue: categories.first { $0.name == "Common" }
            )
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
                guard let newValue else { return }

                Task {
                    imageData = try? await newValue.loadTransferable(type: Data.self)
                }
            }
            .sheet(isPresented: isSheetPresented) {
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
                                    .tag(Optional(category))
                            }
                        }
                    }
                    .navigationTitle("New poster")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                print("Галя отмена")
                                selectedPhoto = nil }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                Task {
                                    savePoster(imageData: imageData, motivationIntensity: tone, posterType: .image, category: choosenCategory!)

                                }
                              
                                selectedPhoto = nil
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
    
    func savePoster(imageData: Data?, motivationIntensity: MotivationIntensity, posterType: PosterType, category: Category) {
        let poster = Poster(
            imageData: imageData,
            motivationIntensity: motivationIntensity,
            posterType: posterType,
            category: category
        )
        modelContext.insert(poster)
        
        dismiss()
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
