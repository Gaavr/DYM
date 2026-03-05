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
                } else if !tipStore.errorMessage.isNilOrEmpty {
                    Text(tipStore.errorMessage!)
                        .foregroundStyle(.red)

                    Button("common.retry") {
                        Task { await tipStore.load(force: true) }
                    }
                } else if tipStore.products.isEmpty {
                    ContentUnavailableView(
                        "donate.unavailable.title",
                        systemImage: "heart",
                        description: Text("donate.unavailable.desc")
                    )

                    Button("common.retry") {
                        Task { await tipStore.load(force: true) }
                    }
                } else {
                    ForEach(tipStore.products, id: \.id) { product in
                        Button {
                            Task {
                                let success = await tipStore.buy(product)
                                if success { dismiss() }
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
                        .disabled(tipStore.isPurchasing)
                    }
                }
            }
            .navigationTitle("donate.title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("common.done") { dismiss() }
                }
            }
            .task {
                await tipStore.load()
            }
        }
    }
}

private extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        switch self {
        case .none: true
        case .some(let s): s.isEmpty
        }
    }
}
