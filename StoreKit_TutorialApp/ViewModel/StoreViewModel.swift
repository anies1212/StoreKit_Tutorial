//
//  StoreViewModel.swift
//  StoreKit_TutorialApp
//
//  Created by 新垣 清奈 on 2022/08/04.
//

import Foundation
import SwiftUI
import StoreKit

final class ViewModel: ObservableObject {
    @Published var storeProducts: [Product] = []
    @Published var purchasedIds: [String] = []
    // Fetch Products
    func fetchProducts(){
        async {
            do {
                let storeProducts = try await Product.products(for: ["com.apple.watch_series_second"])
                DispatchQueue.main.async {
                    self.storeProducts = storeProducts
                }
                if let storeProducts = storeProducts.first {
                    await isPurchased(product: storeProducts)
                }
            }
            catch {
                print(error)
            }
        }
    }
    //Purchase Products
    func purchase() {
        guard let product = storeProducts.first else {
            return
        }
        async {
            do {
                let result = try await product.purchase()
                switch result {

                case .success(let verification):
                    switch verification {
                    case .unverified(_,_):
                        break
                    case .verified(let transaction):
                        DispatchQueue.main.async {
                            self.purchasedIds.append(transaction.productID)
                        }
                    }
                case .userCancelled:
                    break
                case .pending:
                    break
                @unknown default:
                    break
                }
            }
            catch {
                print(error)
            }
        }
    }
    //UpdateUI / Fetch Product Store
    func isPurchased(product: Product) async {
        guard let state = try await product.currentEntitlement else { return }
        switch state {
        case .verified(let transaction):
            DispatchQueue.main.async {
                self.purchasedIds.append(transaction.productID)
            }
        case .unverified(_, _):
            break
        }
    }
}
