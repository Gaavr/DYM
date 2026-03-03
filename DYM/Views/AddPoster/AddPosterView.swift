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
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var imageData: Data?
    @State private var isSaveSheetPresented = false
    @State private var choosenCategory: Category?
    @State private var tone: MotivationIntensity = .any
    
    var categories: [Category]
    
    init(categories: [Category], defaultCategory: Category? = nil) {
        self.categories = categories
        
        let common = categories.first { $0.name == "Common" }
        let initial = defaultCategory ?? common
        
        _choosenCategory = State(initialValue: initial)
    }
    
    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images,
                photoLibrary: .shared()
            ) {
                BigActionButton(title: "poster.photoLibrary", systemImage: "photo.on.rectangle.angled"
                )
            }
            .onChange(of: selectedPhoto) { _, newValue in
                guard let newValue else { return }
                
                Task {
                    let data = try? await newValue.loadTransferable(type: Data.self)
                    presentSaveSheet(with: data)
                    selectedPhoto = nil
                }
            }
            NavigationLink {
                AddQuoteView(
                    chosenCategory: $choosenCategory,
                    tone: $tone,
                    categories: categories,
                    isReady: true,
                    onFinished: { dismiss() }
                )
            } label: {
                BigActionButton(title: "quote.write", systemImage: "quote.bubble")
            }
            
            NavigationLink {
                AddUnsplashView { downloadedData in
                    presentSaveSheet(with: downloadedData)
                }
            } label: {
                BigActionButton(title: "Unsplash", systemImage: "square.and.arrow.down")
            }
            .disabled(true)
            Text("addPoster.unsplash.footer")
                .font(.footnote)
                .foregroundStyle(.secondary)
                
        }
        .sheet(isPresented: $isSaveSheetPresented, onDismiss: { imageData = nil }) {
            SavePosterSheetView(
                isPresented: $isSaveSheetPresented,
                chosenCategory: $choosenCategory,
                tone: $tone,
                categories: categories,
                imageData: imageData,
                isReady: imageData != nil,
                onSave: { category, tone in
                    savePoster(
                        imageData: imageData,
                        motivationIntensity: tone,
                        posterType: .image,
                        category: category
                    )
                    imageData = nil
                }
            )
        }
        .buttonStyle(.plain)
        .navigationTitle(Text("poster.addPoster"))

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
    
    private func presentSaveSheet(with data: Data?) {
        imageData = data
        isSaveSheetPresented = true
    }
}

struct BigActionButton: View {
    let title: LocalizedStringKey
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
    NavigationStack {
        AddPosterView(categories: [.example,  .example])
    }
}
