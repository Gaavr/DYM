//
//  TipsView.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 26.02.2026.
//

import SwiftUI
import StoreKit

struct TipsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var tipStore: TipStore
    
    var body: some View {
        NavigationStack {
            List {
                if tipStore.isLoading {
                    ProgressView("common.loading")
                }
                ForEach(tipStore.products, id: \.id) { product in
                    Button {
                        Task {
                            let success = await tipStore.buy(product)
                            if success {
                                dismiss()
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "heart.fill")
                            Text(product.displayName)
                            Spacer()
                            Text(product.displayPrice)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                if let error = tipStore.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("donate.title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("common.done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TipsView(tipStore: TipStore())
    }
}
