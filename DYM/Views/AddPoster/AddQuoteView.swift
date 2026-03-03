//
//  AddQuoteView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 06.02.2026.
//

import SwiftData
import SwiftUI

struct AddQuoteView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Binding var chosenCategory: Category?
    @Binding var tone: MotivationIntensity
    
    @State private var quoteText: String = ""
    @State private var quoteAuthor: String = ""
    @State private var quoteBackground: UIImage?
    @State private var bgColor1: Color = .indigo
    @State private var bgColor2: Color = .black
    @State private var bgColor3: Color = .purple
    @State private var gradientDirection: GradientDirection = .topLeadingToBottomTrailing
    @State private var gradientKind: GradientKind = .linear
    @State private var radialStart: CGFloat = 20
    @State private var radialEnd: CGFloat = 1200
    
    let categories: [Category]
    let isReady: Bool
    let onFinished: () -> Void
    private let maxQuoteChars = 450;
    private let maxAuthorChars = 50;
    
    private var isSaveDisabled: Bool {
        chosenCategory == nil ||
        quoteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("quote.quote") {
                    TextEditor(text: $quoteText)
                        .frame(minHeight: 150)
                        .scrollContentBackground(.hidden)
                        .onChange(of: quoteText) { _, newValue in
                            if newValue.count > maxQuoteChars {
                                quoteText = String(newValue.prefix(maxQuoteChars))
                            }
                        }
                    TextField("quote.author", text: $quoteAuthor)
                        .onChange(of: quoteAuthor) { _, newValue in
                            if newValue.count > maxAuthorChars {
                                quoteAuthor = String(newValue.prefix(maxAuthorChars))
                            }
                        }
                }
                Section("poster.settings") {
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
                Section("poster.backgroundSettings") {
                    ColorPicker("poster.baseColor", selection: $bgColor1, supportsOpacity: false)
                        .onChange(of: bgColor1) { _, _ in
                            let pair = GradientBackgroundGenerator.randomSecondaryPair()
                            bgColor2 = pair.0
                            bgColor3 = pair.1
                        }
                }
                Section("quote.preview") {
                    QuotePosterPreviewView(
                        text: quoteText,
                        author: quoteAuthor,
                        base: bgColor1,
                        secondary1: bgColor2,
                        secondary2: bgColor3,
                        kind: gradientKind,
                        direction: gradientDirection,
                        radialStart: radialStart,
                        radialEnd: radialEnd,
                        cornerRadius: 20
                    )
                    .aspectRatio(9/16, contentMode: .fill)
                    .contentShape(Rectangle())
                    .onTapGesture { generateBackground() }
                    .overlay(alignment: .top) {
                        Label("settings.tapToChangeBackground", systemImage: "hand.tap")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .padding(15)
                    }
                }
            }
            .navigationTitle("quote.new")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.save") {
                        saveQuotePoster()
                    }
                    .disabled(isSaveDisabled)
                }
            }
            .onAppear {
                let pair = GradientBackgroundGenerator.randomSecondaryPair()
                bgColor2 = pair.0
                bgColor3 = pair.1
                randomizeRadialRadii(for: CGSize(width: 1080, height: 1920))
            }
        }
    }
    
    private func saveQuotePoster() {
        guard let category = chosenCategory else { return }
        
        let png = QuotePosterRenderer.renderPNG(
            text: quoteText,
            author: quoteAuthor,
            base: bgColor1,
            secondary1: bgColor2,
            secondary2: bgColor3,
            kind: gradientKind,
            direction: gradientDirection,
            radialStart: radialStart,
            radialEnd: radialEnd
        )
        
        guard let png else { return }
        
        let poster = Poster(
            imageData: png,
            motivationIntensity: tone,
            posterType: .quote,
            category: category
        )
        
        modelContext.insert(poster)
        dismiss()
        onFinished()
    }
    
    private func randomizeRadialRadii(for size: CGSize) {
        let minSide = min(size.width, size.height)
        radialStart = .random(in: minSide * 0.01 ... minSide * 0.06)
        radialEnd   = .random(in: minSide * 0.90 ... minSide * 1.35)
    }
    
    private func generateBackground() {
        randomizeRadialRadii(for: CGSize(width: 1080, height: 1920))
        let pair = GradientBackgroundGenerator.randomSecondaryPair()
        bgColor2 = pair.0
        bgColor3 = pair.1
        
        gradientDirection = GradientBackgroundGenerator.randomDirection()
        gradientKind = GradientBackgroundGenerator.randomKind()
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var chosen: Category? = .example
        @State private var tone: MotivationIntensity = .any
        
        var body: some View {
            NavigationStack {
                AddQuoteView(
                    chosenCategory: $chosen,
                    tone: $tone,
                    categories: [.example, .example],
                    isReady: true,
                    onFinished: {}
                )
            }
        }
    }
    
    return PreviewWrapper()
}
