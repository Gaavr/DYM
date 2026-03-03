//
//  TipStore.swift
//  DYM
//
//  Created by Andrei Gavrilenko on 26.02.2026.
//

import Combine
import StoreKit
import SwiftUI

@MainActor
final class TipStore: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let productIDs: [String] = [
        "support.basic",
        "support.extended",
        "support.maximum"
    ]
    
    private var updatesTask: Task<Void, Never>?
    
    func startListening() {
        guard updatesTask == nil else { return }
        updatesTask = Task {
            for await result in Transaction.updates {
                do {
                    let transaction = try verified(result)
                    await transaction.finish()
                } catch {
                    print("Transaction update failed: \(error)")
                }
            }
        }
    }
    
    func stopListening() {
        updatesTask?.cancel()
        updatesTask = nil
    }
    
    deinit {
        updatesTask?.cancel()
    }
    
    func load() async {
        guard products.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let loaded = try await Product.products(for: productIDs)
            products = loaded.sorted { $0.price < $1.price }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    func buy(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try verified(verification)
                await transaction.finish()
                return true
                
            case .userCancelled, .pending:
                return false
                
            @unknown default:
                return false
            }
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    private func verified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw NSError(
                domain: "TipStore",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Transaction verification failed"]
            )
        }
    }
}
