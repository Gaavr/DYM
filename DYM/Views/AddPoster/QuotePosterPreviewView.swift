//
//  Untitled.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 24.02.2026.
//

import SwiftUI

struct QuotePosterPreviewView: View {
    let text: String
    let author: String
    let base: Color
    let secondary1: Color
    let secondary2: Color
    let kind: GradientKind
    let direction: GradientDirection

    var body: some View {
        ZStack {
            GradientBackgroundGenerator.makeView(
                base: base,
                secondary1: secondary1,
                secondary2: secondary2,
                kind: kind,
                direction: direction
            )

            VStack {
                Spacer()

                Text("“\(text.isEmpty ? "Your quote will appear here" : text)”")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)

                Spacer()

                if !author.isEmpty {
                    Text("— \(author)")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.bottom, 24)
                }
            }
        }
        .frame(height: 600)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
