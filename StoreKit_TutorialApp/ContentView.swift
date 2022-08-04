//
//  ContentView.swift
//  StoreKit_TutorialApp
//
//  Created by 新垣 清奈 on 2022/08/04.
//


import SwiftUI
import StoreKit

struct ContentView: View {
    @StateObject var viewModel = ViewModel()


    var body: some View {
        VStack{
            Image(systemName: "applelogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
            Text("Apple Store")
                .bold()
                .font(.system(size: 32))
            Image("apple_watch")
                .resizable()
                .aspectRatio(nil,contentMode: .fit)
            if let product = viewModel.storeProducts.first {
                Text(product.displayName)
                Text(product.description)
                Button(action: {
                    viewModel.purchasedIds.isEmpty ? viewModel.purchase() : viewModel.fetchProducts()
                }) {
                    Text(viewModel.purchasedIds.isEmpty ? "Buy Now \(product.displayPrice)" : "Purchased")
                        .bold()
                        .font(.system(size: 22))
                        .foregroundColor(Color.white)
                        .frame(width: 220, height: 50)
                        .background(viewModel.purchasedIds.isEmpty ? Color.blue : Color.green)
                        .cornerRadius(8)
                }
            }
        }
        .onAppear {
            viewModel.fetchProducts()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
