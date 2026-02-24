//
//  AddQuoteView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 06.02.2026.
//

import SwiftUI

struct AddQuoteView: View {
    
    let categories: [Category]
    let isReady: Bool
    
    @State private var quoteText: String = ""
    @State private var quoteAuthor: String = ""
    @State private var quoteBackground: UIImage?
    
    @State private var bgColor1: Color = .indigo
    @State private var bgColor2: Color = .black
    @State private var bgColor3: Color = .purple
    @State private var gradientDirection: GradientDirection = .topLeadingToBottomTrailing
    @State private var gradientKind: GradientKind = .linear
    
    @Binding var isPresented: Bool
    @Binding var chosenCategory: Category?
    @Binding var tone: MotivationIntensity
    
    let onSave: (Category, MotivationIntensity) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Quote") {
                    TextEditor(text: $quoteText)
                        .frame(minHeight: 150)
                        .scrollContentBackground(.hidden)
                    TextField("Author", text: $quoteAuthor)
                }
                Section("Poster Settings") {
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
                Section("Background settigns") {
                    ColorPicker("Base color", selection: $bgColor1, supportsOpacity: false)
                        .onChange(of: bgColor1) { _, _ in
                            let pair = GradientBackgroundGenerator.randomSecondaryPair()
                            bgColor2 = pair.0
                            bgColor3 = pair.1
                        }
                    Button("Generate bakcground") {
                        let pair = GradientBackgroundGenerator.randomSecondaryPair()
                        bgColor2 = pair.0
                        bgColor3 = pair.1
                        
                        gradientDirection = GradientBackgroundGenerator.randomDirection()
                        gradientKind = GradientBackgroundGenerator.randomKind()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .buttonStyle(.borderedProminent)
                }
                Section("Preview") {
                    QuotePosterPreviewView(text: quoteText, author: quoteAuthor, base: bgColor1, secondary1: bgColor2, secondary2: bgColor3, kind: gradientKind, direction: gradientDirection)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("New quote")
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
            .onAppear {
                let pair = GradientBackgroundGenerator.randomSecondaryPair()
                bgColor2 = pair.0
                bgColor3 = pair.1
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var isPresented: Bool = true
        @State var chosenCategory: Category? = Category(
            name: "Motivation",
            categoryDescription: "Daily motivation",
            color: .blue,
            icon: "🔥"
        )
        @State var tone: MotivationIntensity = .any
        
        let categories: [Category] = [
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
        
        var body: some View {
            AddQuoteView(
                categories: categories,
                isReady: true,
                isPresented: $isPresented,
                chosenCategory: $chosenCategory,
                tone: $tone,
                onSave: { _, _ in }
            )
        }
    }
    
    return NavigationStack {
        PreviewWrapper()
    }
}
