//
//  QuotePosterRenderer.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 24.02.2026.
//

import SwiftUI

@MainActor
enum QuotePosterRenderer {
    
    static func renderPNG(
        text: String,
        author: String,
        base: Color,
        secondary1: Color,
        secondary2: Color,
        kind: GradientKind, 
        direction: GradientDirection,
        radialStart: CGFloat,
        radialEnd: CGFloat
    ) -> Data? {
        
        let size = CGSize(width: 1080, height: 1920)
        let scale: CGFloat = 2
        
        let view = QuotePosterPreviewView(
            text: text,
            author: author,
            base: base,
            secondary1: secondary1,
            secondary2: secondary2,
            kind: kind,
            direction: direction,
            radialStart: radialStart,
            radialEnd: radialEnd,
            cornerRadius: 0
        )
            .frame(width: size.width, height: size.height)
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = scale
        
        guard let uiImage = renderer.uiImage else { return nil }
        return uiImage.pngData()
    }
}
