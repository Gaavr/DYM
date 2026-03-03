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
    let radialStart: CGFloat
    let radialEnd: CGFloat
    var cornerRadius: CGFloat = 20
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let quoteFont = max(28, w * 0.06)
            let authorFont = max(16, w * 0.035)
            
            ZStack {
                if kind == .radial {
                    RadialGradient(
                        gradient: Gradient(colors: [base, secondary1, secondary2]),
                        center: .center,
                        startRadius: radialStart,
                        endRadius: radialEnd
                    )
                    .ignoresSafeArea()
                } else {
                    GradientBackgroundGenerator.makeView(
                        base: base,
                        secondary1: secondary1,
                        secondary2: secondary2,
                        kind: kind,
                        direction: direction
                    )
                    .ignoresSafeArea()
                }
                
                VStack {
                    Spacer()
                    if text.isEmpty {
                        Text(LocalizedStringKey("quote.example"))
                            .font(.system(size: quoteFont, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.horizontal, w * 0.08)
                            .minimumScaleFactor(0.6)
                    } else {
                        Text(text)
                            .font(.system(size: quoteFont, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.horizontal, w * 0.08)
                            .minimumScaleFactor(0.6)
                    }
                    Spacer()
                    if !author.isEmpty {
                        Text("— \(author)")
                            .font(.system(size: authorFont, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.bottom, w * 0.06)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }
}
