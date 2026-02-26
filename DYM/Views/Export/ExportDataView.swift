//
//  ExportDataView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 26.02.2026.
//

import SwiftData
import SwiftUI
import UIKit

struct ExportDataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [Category]
    
    @State private var selectedCategory: Category?
    @State private var shareItem: ShareItem?
    @State private var exportError: String?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section {
                Picker("category.category", selection: $selectedCategory) {
                    Text("common.select").tag(Category?.none)
                    ForEach(categories) { c in
                        Text(c.name).tag(Category?.some(c))
                    }
                }
            } header: {
                Text("export.section.header")
            } footer: {
                Text("export.section.footer")
            }
            
            Section {
                Button {
                    exportAndShare()
                } label: {
                    Label("export.button.title", systemImage: "square.and.arrow.up")
                }
                .foregroundStyle(selectedCategory == nil ? .secondary : Color(.systemBlue))
                .disabled(selectedCategory == nil)
            }
        }
        .navigationTitle("export.nav.title")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $shareItem) { item in
            ShareSheet(items: [item.url]) {
                shareItem = nil
                dismiss()
            }
        }
        .alert("export.alert.failed.title", isPresented: Binding(
            get: { exportError != nil },
            set: { if !$0 { exportError = nil } }
        )) {
            Button("common.ok") { exportError = nil }
        } message: {
            Text(exportError ?? "")
        }
    }
    
    private func exportAndShare() {
        guard let category = selectedCategory else { return }
        
        do {
            let categoryID = category.id
            let descriptor = FetchDescriptor<Poster>(
                predicate: #Predicate { $0.category.id == categoryID }
            )
            let posters = try modelContext.fetch(descriptor)
            
            let url = try PostersZipExporter.makeZip(
                categoryName: category.name,
                posters: posters
            )
            
            shareItem = ShareItem(url)
        } catch {
            exportError = String(describing: error)
        }
    }
}

#Preview("ExportDataView") {
    NavigationStack {
        ExportDataView()
    }
}

