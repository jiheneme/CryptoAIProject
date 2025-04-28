//
//  CryptoListView.swift
//  CryptoAI
//
//  Created by Jihene on 28/04/2025.
//
import SwiftUI

struct CryptoListView: View {
    @StateObject private var viewModel = CryptoViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let lastUpdated = viewModel.lastUpdated {
                    Text("Last update : \(viewModel.formattedDate(date: lastUpdated))")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }

                Group {
                    if viewModel.cryptos.isEmpty {
                        VStack {
                            Spacer()
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(1.5)
                            Spacer()
                        }
                    } else {
                        List(viewModel.cryptos) { crypto in
                            CryptoRowView(crypto: crypto)
                        }
                        .listStyle(.plain)
                        .refreshable {
                            viewModel.fetchCryptos()
                        }
                    }
                }
            }
            .navigationTitle("CryptoAI 🤖")
        }
    }
}

struct CryptoRowView: View {
    let crypto: Crypto

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: crypto.image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(crypto.name)
                    .font(.headline)

                Text("$\(crypto.current_price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .transition(.opacity)
                    .id(crypto.current_price)
                    .animation(.easeInOut(duration: 0.4), value: crypto.current_price)
            }

            Spacer()

            if let change = crypto.price_change_percentage_24h {
                Text(String(format: "%.2f%%", change))
                    .font(.subheadline)
                    .foregroundColor(change >= 0 ? .green : .red)
                    .transition(.opacity)
                    .id(change)
                    .animation(.easeInOut(duration: 0.4), value: change)
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    CryptoListView()
}
