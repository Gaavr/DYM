//
//  ActivityView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 26.02.2026.
//
import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let onComplete: () -> Void
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.completionWithItemsHandler = { _, _, _, _ in
            onComplete()
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ShareItem: Identifiable {
    let id: String
    let url: URL
    
    init(_ url: URL) {
        self.url = url
        self.id = url.absoluteString
    }
}
